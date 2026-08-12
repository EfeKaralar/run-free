// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';
import 'package:run_free/src/domain/services/location_tracker.dart';
import 'package:tracelet/tracelet.dart' as tl;

/// [LocationTracker] backed by Tracelet.
///
/// Everything Tracelet-shaped is confined to this file — the `tl.` prefix on
/// every reference below is a deliberate reminder of where the boundary is.
class TraceletLocationTracker implements LocationTracker {
  final _controller = StreamController<TrackPoint>.broadcast();

  StreamSubscription<tl.Location>? _locationSub;
  bool _isReady = false;

  @override
  Stream<TrackPoint> get positions => _controller.stream;

  @override
  Future<TrackingPermission> checkPermission() async {
    final status = await tl.Tracelet.getLocationAuthorization();
    return _mapAuthorization(status);
  }

  @override
  Future<TrackingPermission> requestPermission() async {
    var status = _mapAuthorization(
      await tl.Tracelet.requestLocationAuthorization(),
    );

    // Android 10+ and iOS both refuse to grant background access in the same
    // prompt as foreground access. The second request is only meaningful once
    // the first has succeeded, and on iOS it is what triggers the "Change to
    // Always Allow?" prompt.
    if (status == TrackingPermission.whileInUse) {
      status = _mapAuthorization(
        await tl.Tracelet.requestLocationAuthorization(),
      );
    }

    // Motion access is optional: without it Tracelet falls back to raw
    // accelerometer sampling, which costs battery but still works. A refusal
    // must not block recording.
    try {
      await tl.Tracelet.requestMotionAuthorization();
    } on Object catch (error, stack) {
      debugPrintStack(
        label: 'Motion authorization unavailable: $error',
        stackTrace: stack,
      );
    }

    return status;
  }

  @override
  Future<void> start(ActivityType type) async {
    await tl.Tracelet.ready(_configFor(type));
    _isReady = true;

    // Subscribe before start() so no fix is lost in the gap.
    _locationSub ??= tl.Tracelet.onLocation((location) {
      final point = _toTrackPoint(location);
      if (point != null && !_controller.isClosed) {
        _controller.add(point);
      }
    });

    await tl.Tracelet.start();
  }

  @override
  Future<void> stop() async {
    await _locationSub?.cancel();
    _locationSub = null;
    if (_isReady) {
      await tl.Tracelet.stop();
    }
  }

  @override
  Future<void> setMoving(bool isMoving) async {
    if (!_isReady) return;
    await tl.Tracelet.changePace(isMoving);
  }

  @override
  Future<TrackPoint?> currentPosition() async {
    try {
      // `ready` has to have run at least once before the native side will
      // answer, so fall back to a cheap default config when the user opens the
      // app and has not started recording yet.
      if (!_isReady) {
        await tl.Tracelet.ready(_configFor(ActivityType.run));
        _isReady = true;
      }
      final location = await tl.Tracelet.getCurrentPosition();
      return _toTrackPoint(location);
    } on Object catch (error) {
      // No fix indoors, permission revoked mid-session, airplane mode. The map
      // simply stays at its default view; this is not worth surfacing.
      debugPrint('Could not obtain current position: $error');
      return null;
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }

  /// Per-sport tuning.
  ///
  /// The distance filter is the main lever: it is the minimum movement before
  /// a new fix is emitted. Too small and a stationary phone fills the track
  /// with jitter; too large and tight switchbacks get cut into straight lines.
  tl.Config _configFor(ActivityType type) {
    final distanceFilter = switch (type) {
      // Cyclists cover ground fast; a wider filter still yields a dense track.
      ActivityType.ride => 10.0,
      // Runners want corners captured accurately.
      ActivityType.run => 5.0,
      // Walking and hiking are slow enough that a tight filter would mostly
      // record GPS noise.
      ActivityType.walk || ActivityType.hike => 8.0,
    };

    return tl.Config.highAccuracy().copyWith(
      geo: tl.GeoConfig(
        desiredAccuracy: tl.DesiredAccuracy.high,
        distanceFilter: distanceFilter,
        // Elasticity scales the filter with speed to save battery. Fine for
        // commute tracking, wrong for sport: it quietly degrades track detail
        // exactly when the user is moving fastest.
        disableElasticity: true,
        filter: const tl.LocationFilter(
          // A spoofed fix in a fitness log is a corrupt record, not a
          // security problem, but there is no reason to store one.
          rejectMockLocations: true,
        ),
      ),
      app: const tl.AppConfig(
        // Keep recording if the OS or the user kills the UI mid-run; losing an
        // activity because someone swiped the app away is unforgivable.
        stopOnTerminate: false,
        // But do not resurrect tracking on reboot — Run Free only records when
        // the user explicitly asks it to.
        startOnBoot: false,
      ),
      persistence: const tl.PersistenceConfig(
        // Tracelet's own SQLite queue is only a crash-recovery buffer here;
        // the durable copy lives in Run Free's database. Keep it short.
        maxDaysToPersist: 1,
      ),
      android: const tl.AndroidConfig(
        foregroundService: tl.ForegroundServiceConfig(
          enabled: true,
          channelName: 'Activity recording',
          notificationTitle: 'Run Free is recording',
          notificationText: 'Tracking your activity',
        ),
      ),
      ios: const tl.IosConfig(
        // Tells CoreLocation this is a fitness session, which changes its
        // internal filtering and pause heuristics.
        activityType: tl.LocationActivityType.fitness,
        // iOS will otherwise decide on its own that the user has stopped and
        // silently end location updates, truncating the activity.
        pausesLocationUpdatesAutomatically: false,
        // The blue status bar pill. Required by App Review for background
        // location, and honest to show.
        showsBackgroundLocationIndicator: true,
      ),
    );
  }

  TrackPoint? _toTrackPoint(tl.Location location) {
    final timestamp = DateTime.tryParse(location.timestamp);
    if (timestamp == null) return null;

    final coords = location.coords;
    return TrackPoint(
      timestamp: timestamp.toUtc(),
      latitude: coords.latitude,
      longitude: coords.longitude,
      altitude: coords.altitude,
      speed: coords.speed >= 0 ? coords.speed : null,
      accuracy: coords.accuracy >= 0 ? coords.accuracy : null,
      heading: coords.heading >= 0 ? coords.heading : null,
    );
  }

  TrackingPermission _mapAuthorization(tl.AuthorizationStatus status) {
    return switch (status) {
      tl.AuthorizationStatus.notDetermined => TrackingPermission.notDetermined,
      tl.AuthorizationStatus.denied => TrackingPermission.denied,
      tl.AuthorizationStatus.whenInUse => TrackingPermission.whileInUse,
      tl.AuthorizationStatus.always => TrackingPermission.always,
      _ => TrackingPermission.denied,
    };
  }
}