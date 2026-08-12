// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_free/src/core/units.dart';
import 'package:run_free/src/data/repositories/activity_repository.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';
import 'package:run_free/src/domain/services/location_tracker.dart';
import 'package:run_free/src/domain/services/stats_calculator.dart';
import 'package:run_free/src/features/recording/recording_state.dart';
import 'package:run_free/src/providers.dart';
import 'package:uuid/uuid.dart';

/// Drives a recording session from start to saved activity.
///
/// Deliberately the only place that mutates recording state. The screen reads
/// [RecordingState] and calls the methods below; it owns no session state of
/// its own, which is what makes the session survive navigation.
class RecordingController extends Notifier<RecordingState> {
  RecordingController({
    this.calculator = const StatsCalculator(),
    this.uuid = const Uuid(),
  });

  /// Injectable so tests can pin thresholds and ids; both have sane defaults
  /// so production construction stays argument-free.
  final StatsCalculator calculator;
  final Uuid uuid;

  // Collaborators come from the provider graph rather than the constructor, so
  // tests swap them by overriding `locationTrackerProvider` and
  // `activityRepositoryProvider` on a ProviderContainer — which exercises the
  // real wiring instead of bypassing it.
  late final LocationTracker _tracker = ref.read(locationTrackerProvider);
  late final ActivityRepository _repository = ref.read(
    activityRepositoryProvider,
  );

  /// Read at save time, not cached: if the user switches to imperial midway
  /// through a run, their splits should come out in miles.
  UnitSystem get _units => ref.read(unitSystemProvider);

  StreamSubscription<TrackPoint>? _positionSub;
  Timer? _elapsedTimer;

  /// Total time spent paused, subtracted from wall-clock elapsed time.
  Duration _pausedDuration = Duration.zero;
  DateTime? _pausedAt;

  @override
  RecordingState build() {
    ref.onDispose(() {
      _positionSub?.cancel();
      _elapsedTimer?.cancel();
    });
    return const RecordingState();
  }

  /// Checks (without prompting) what access we already have, so the screen can
  /// show the right call to action on first paint.
  Future<void> refreshPermission() async {
    final permission = await _tracker.checkPermission();
    state = state.copyWith(permission: permission);
  }

  void selectActivityType(ActivityType type) {
    // Changing sport mid-session would invalidate the tuning the tracker was
    // started with, and the stats already accumulated.
    if (state.isActive || state.isBusy) return;
    state = state.copyWith(activityType: type);
  }

  /// Requests location access, escalating to background access.
  Future<TrackingPermission> requestPermission() async {
    final permission = await _tracker.requestPermission();
    state = state.copyWith(permission: permission, clearError: true);
    return permission;
  }

  /// Begins a new recording session.
  Future<void> start() async {
    if (state.isActive || state.isBusy) return;

    state = state.copyWith(
      status: RecordingStatus.preparing,
      clearError: true,
    );

    var permission = state.permission;
    if (!permission.canRecord) {
      permission = await requestPermission();
    }
    if (!permission.canRecord) {
      state = state
          .copyWith(status: RecordingStatus.idle)
          .withError(
            'Run Free needs location access to record your route. '
            'You can grant it in system settings.',
          );
      return;
    }

    try {
      await _tracker.start(state.activityType);
    } on Object catch (error) {
      state = state
          .copyWith(status: RecordingStatus.idle)
          .withError('Could not start tracking: $error');
      return;
    }

    _pausedDuration = Duration.zero;
    _pausedAt = null;

    _positionSub?.cancel();
    _positionSub = _tracker.positions.listen(_onPosition);

    // Elapsed time must keep ticking between GPS fixes, otherwise the timer
    // visibly stalls whenever the user stops at a crossing.
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tickElapsed(),
    );

    state = state.copyWith(
      status: RecordingStatus.recording,
      startedAt: DateTime.now().toUtc(),
      points: const [],
      stats: ActivityStats.empty,
      clearError: true,
    );
  }

  Future<void> pause() async {
    if (state.status != RecordingStatus.recording) return;
    _pausedAt = DateTime.now().toUtc();
    state = state.copyWith(status: RecordingStatus.paused);
    // Tell the tracker directly rather than waiting for motion detection to
    // notice; this drops GPS to its stationary duty cycle immediately.
    await _tracker.setMoving(false);
  }

  Future<void> resume() async {
    if (state.status != RecordingStatus.paused) return;
    final pausedAt = _pausedAt;
    if (pausedAt != null) {
      _pausedDuration += DateTime.now().toUtc().difference(pausedAt);
      _pausedAt = null;
    }
    state = state.copyWith(status: RecordingStatus.recording);
    await _tracker.setMoving(true);
  }

  /// Ends the session and writes it to the database.
  ///
  /// Returns the new activity's id, or `null` if the session was discarded for
  /// having no usable track.
  Future<String?> stop() async {
    if (!state.isActive) return null;

    state = state.copyWith(status: RecordingStatus.saving);

    await _positionSub?.cancel();
    _positionSub = null;
    _elapsedTimer?.cancel();
    _elapsedTimer = null;

    try {
      await _tracker.stop();
    } on Object catch (error) {
      // A failure to stop the native tracker must not cost the user their
      // activity — carry on and save what was recorded.
      state = state.withError('Tracking did not stop cleanly: $error');
    }

    if (!state.hasSaveableTrack) {
      _resetSession();
      return null;
    }

    final startedAt = state.startedAt ?? state.points.first.timestamp;
    final endedAt = state.points.last.timestamp;
    final elapsed = _currentElapsed();

    final stats = calculator.compute(state.points, elapsed: elapsed);
    final laps = calculator.computeLaps(
      state.points,
      splitDistanceMeters: _units.splitDistanceMeters,
    );

    final activity = Activity(
      id: uuid.v4(),
      type: state.activityType,
      startedAt: startedAt,
      endedAt: endedAt,
      stats: stats,
      points: state.points,
      laps: laps,
    );

    try {
      await _repository.saveActivity(activity);
    } on Object catch (error) {
      // Keep the session alive so the user can retry rather than losing the run.
      state = state
          .copyWith(status: RecordingStatus.paused)
          .withError('Could not save the activity: $error');
      return null;
    }

    _resetSession(savedActivityId: activity.id);
    return activity.id;
  }

  /// Throws away the current session without saving.
  Future<void> discard() async {
    if (!state.isActive) return;
    await _positionSub?.cancel();
    _positionSub = null;
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    await _tracker.stop();
    _resetSession();
  }

  void _onPosition(TrackPoint point) {
    // Fixes still arrive while paused (the tracker only reduces its rate).
    // Recording them would draw a line across whatever the user did during the
    // pause, so they are dropped.
    if (state.status != RecordingStatus.recording) return;

    final points = [...state.points, point];
    state = state.copyWith(
      points: points,
      stats: calculator.compute(points, elapsed: _currentElapsed()),
    );
  }

  void _tickElapsed() {
    if (state.status != RecordingStatus.recording) return;
    state = state.copyWith(
      stats: state.stats.copyWith(elapsedDuration: _currentElapsed()),
    );
  }

  Duration _currentElapsed() {
    final startedAt = state.startedAt;
    if (startedAt == null) return Duration.zero;
    final pausedSoFar =
        _pausedDuration +
        (_pausedAt != null
            ? DateTime.now().toUtc().difference(_pausedAt!)
            : Duration.zero);
    final elapsed = DateTime.now().toUtc().difference(startedAt) - pausedSoFar;
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  void _resetSession({String? savedActivityId}) {
    _pausedDuration = Duration.zero;
    _pausedAt = null;
    state = RecordingState(
      activityType: state.activityType,
      permission: state.permission,
      lastSavedActivityId: savedActivityId ?? state.lastSavedActivityId,
    );
  }
}