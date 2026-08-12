// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';

/// How much location access the user has granted.
enum TrackingPermission {
  /// Never asked.
  notDetermined,

  /// Refused. Recording is impossible.
  denied,

  /// Foreground only. Recording works while the app is on screen, but the
  /// track will have holes once the user locks their phone — which is what
  /// everyone does during a run.
  whileInUse,

  /// Full background access. The only state where recording is reliable.
  always,
}

extension TrackingPermissionX on TrackingPermission {
  /// Whether recording can start at all.
  bool get canRecord =>
      this == TrackingPermission.always ||
      this == TrackingPermission.whileInUse;

  /// Whether the track will survive the screen turning off.
  bool get isBackgroundCapable => this == TrackingPermission.always;
}

/// Abstraction over the platform's background geolocation.
///
/// Tracelet is the only implementation today, but the recording controller is
/// written against this interface so that (a) it can be driven by a fake in
/// tests without a device, and (b) replacing the geolocation engine does not
/// reach into the UI.
abstract interface class LocationTracker {
  /// Fixes delivered while tracking is active.
  ///
  /// A broadcast stream: the recording controller and the live map both listen.
  Stream<TrackPoint> get positions;

  Future<TrackingPermission> checkPermission();

  /// Prompts for location access, escalating to background access if needed.
  Future<TrackingPermission> requestPermission();

  /// Begins delivering fixes, tuned for [type].
  Future<void> start(ActivityType type);

  Future<void> stop();

  /// Tells the tracker the user is stationary (or moving again) instead of
  /// waiting for motion detection to work it out. Used when the user pauses.
  Future<void> setMoving(bool isMoving);

  /// A single fix, for centring the map before recording starts.
  Future<TrackPoint?> currentPosition();

  Future<void> dispose();
}