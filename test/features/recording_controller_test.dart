// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_free/src/data/database/database.dart';
import 'package:run_free/src/data/repositories/activity_repository.dart';
import 'package:run_free/src/data/repositories/drift_activity_repository.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';
import 'package:run_free/src/domain/services/location_tracker.dart';
import 'package:run_free/src/features/recording/recording_controller.dart';
import 'package:run_free/src/features/recording/recording_state.dart';
import 'package:run_free/src/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/stats_calculator_test.dart' show straightTrack;

/// A [LocationTracker] whose fixes the test drives by hand.
class FakeLocationTracker implements LocationTracker {
  final _controller = StreamController<TrackPoint>.broadcast();

  TrackingPermission permissionToGrant = TrackingPermission.always;
  bool startCalled = false;
  bool stopCalled = false;
  bool? lastSetMoving;
  Object? startError;
  ActivityType? startedWithType;

  @override
  Stream<TrackPoint> get positions => _controller.stream;

  @override
  Future<TrackingPermission> checkPermission() async => permissionToGrant;

  @override
  Future<TrackingPermission> requestPermission() async => permissionToGrant;

  @override
  Future<void> start(ActivityType type) async {
    if (startError != null) throw startError!;
    startCalled = true;
    startedWithType = type;
  }

  @override
  Future<void> stop() async => stopCalled = true;

  @override
  Future<void> setMoving(bool isMoving) async => lastSetMoving = isMoving;

  @override
  Future<TrackPoint?> currentPosition() async => null;

  @override
  Future<void> dispose() async => _controller.close();

  /// Delivers a fix, and yields so the controller's listener runs.
  Future<void> emit(TrackPoint point) async {
    _controller.add(point);
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> emitAll(Iterable<TrackPoint> points) async {
    for (final point in points) {
      await emit(point);
    }
  }
}

void main() {
  late AppDatabase db;
  late ActivityRepository repository;
  late FakeLocationTracker tracker;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftActivityRepository(db);
    tracker = FakeLocationTracker();

    // Overriding providers rather than constructing the controller directly
    // means the real wiring is under test too.
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        activityRepositoryProvider.overrideWithValue(repository),
        locationTrackerProvider.overrideWithValue(tracker),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  RecordingController controller() =>
      container.read(recordingControllerProvider.notifier);
  RecordingState state() => container.read(recordingControllerProvider);

  test('starts idle', () {
    expect(state().status, RecordingStatus.idle);
    expect(state().points, isEmpty);
  });

  test('start moves to recording and starts the tracker', () async {
    await controller().start();

    expect(state().status, RecordingStatus.recording);
    expect(tracker.startCalled, isTrue);
    expect(state().startedAt, isNotNull);
  });

  test('the tracker is tuned for the selected sport', () async {
    controller().selectActivityType(ActivityType.ride);
    await controller().start();

    expect(tracker.startedWithType, ActivityType.ride);
  });

  test('the sport cannot be changed mid-session', () async {
    await controller().start();
    controller().selectActivityType(ActivityType.hike);

    expect(state().activityType, ActivityType.run);
  });

  test('denied permission fails with an error and stays idle', () async {
    tracker.permissionToGrant = TrackingPermission.denied;

    await controller().start();

    expect(state().status, RecordingStatus.idle);
    expect(state().error, isNotNull);
    expect(tracker.startCalled, isFalse);
  });

  test('a tracker that fails to start surfaces the error', () async {
    tracker.startError = StateError('GPS unavailable');

    await controller().start();

    expect(state().status, RecordingStatus.idle);
    expect(state().error, contains('Could not start tracking'));
  });

  test('incoming fixes accumulate and update the live stats', () async {
    await controller().start();
    await tracker.emitAll(straightTrack(count: 11));

    expect(state().points.length, 11);
    expect(state().stats.distanceMeters, closeTo(100, 2));
  });

  test('fixes arriving while paused are discarded', () async {
    await controller().start();
    await tracker.emitAll(straightTrack(count: 5));

    await controller().pause();
    expect(state().status, RecordingStatus.paused);
    expect(tracker.lastSetMoving, isFalse);

    await tracker.emitAll(straightTrack(count: 5));

    expect(
      state().points.length,
      5,
      reason: 'a paused activity must not record the walk to the car',
    );
  });

  test('resume tells the tracker it is moving again', () async {
    await controller().start();
    await controller().pause();
    await controller().resume();

    expect(state().status, RecordingStatus.recording);
    expect(tracker.lastSetMoving, isTrue);
  });

  test('stop saves the activity and returns to idle', () async {
    await controller().start();
    await tracker.emitAll(straightTrack(count: 11));

    final id = await controller().stop();

    expect(id, isNotNull);
    expect(tracker.stopCalled, isTrue);
    expect(state().status, RecordingStatus.idle);
    expect(state().points, isEmpty);

    final saved = await repository.getActivity(id!);
    expect(saved, isNotNull);
    expect(saved!.points.length, 11);
    expect(saved.type, ActivityType.run);
    expect(saved.stats.distanceMeters, closeTo(100, 2));
  });

  test('stopping with too short a track saves nothing', () async {
    await controller().start();
    await tracker.emitAll(straightTrack(count: 1));

    final id = await controller().stop();

    expect(id, isNull);
    expect(await repository.countActivities(), 0);
    expect(state().status, RecordingStatus.idle);
  });

  test('splits are computed and persisted on save', () async {
    await controller().start();
    // 2 km, so two full kilometre splits.
    await tracker.emitAll(straightTrack(count: 201, spacingMeters: 10));

    final id = await controller().stop();
    final saved = await repository.getActivity(id!);

    expect(saved!.laps.length, 2);
    expect(saved.laps.first.distanceMeters, closeTo(1000, 1));
  });

  test('discard throws the session away without saving', () async {
    await controller().start();
    await tracker.emitAll(straightTrack(count: 11));

    await controller().discard();

    expect(state().status, RecordingStatus.idle);
    expect(await repository.countActivities(), 0);
    expect(tracker.stopCalled, isTrue);
  });

  test('start is ignored while a session is already running', () async {
    await controller().start();
    final startedAt = state().startedAt;

    await controller().start();

    expect(
      state().startedAt,
      startedAt,
      reason: 'a double tap must not restart the session',
    );
  });

  test('refreshPermission reports what the tracker already holds', () async {
    tracker.permissionToGrant = TrackingPermission.whileInUse;

    await controller().refreshPermission();

    expect(state().permission, TrackingPermission.whileInUse);
    expect(state().permission.canRecord, isTrue);
    expect(state().permission.isBackgroundCapable, isFalse);
  });
}
