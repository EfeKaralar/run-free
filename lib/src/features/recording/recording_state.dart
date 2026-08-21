// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';
import 'package:run_free/src/domain/services/location_tracker.dart';

/// Where a recording session currently is.
enum RecordingStatus {
  /// Nothing being recorded. The start button is showing.
  idle,

  /// Permissions and the native tracker are being set up. Brief, but the UI
  /// must not let the user press start twice during it.
  preparing,

  recording,

  paused,

  /// Writing to the database. Also brief, and also must not be re-entered.
  saving,
}

/// Immutable snapshot of the recording screen's state.
class RecordingState {
  const RecordingState({
    this.status = RecordingStatus.idle,
    this.activityType = ActivityType.run,
    this.points = const [],
    this.stats = ActivityStats.empty,
    this.permission = TrackingPermission.notDetermined,
    this.startedAt,
    this.error,
    this.lastSavedActivityId,
  });

  final RecordingStatus status;
  final ActivityType activityType;

  /// Fixes accumulated so far. Kept in memory during the session and written to
  /// the database once, on stop.
  ///
  /// An hour of running is roughly 3,600 points — a few hundred kilobytes.
  /// Streaming each point to SQLite as it arrives would survive a crash, but
  /// costs a write per second for the entire activity. Worth revisiting if
  /// crash reports say otherwise; Tracelet's own queue is the backstop.
  final List<TrackPoint> points;

  final ActivityStats stats;
  final TrackingPermission permission;

  /// Wall-clock start, used to compute elapsed time including pauses.
  final DateTime? startedAt;

  /// Set when something failed. The UI shows it and lets the user retry.
  final String? error;

  /// Id of the activity written by the most recent [stop], so the screen can
  /// navigate to its detail page.
  final String? lastSavedActivityId;

  bool get isActive =>
      status == RecordingStatus.recording || status == RecordingStatus.paused;

  /// Whether the UI should block interaction on an in-flight transition.
  bool get isBusy =>
      status == RecordingStatus.preparing || status == RecordingStatus.saving;

  /// Only worth saving if there is a real track behind it. Two points is the
  /// minimum that can produce a distance.
  bool get hasSaveableTrack => points.length >= 2;

  RecordingState copyWith({
    RecordingStatus? status,
    ActivityType? activityType,
    List<TrackPoint>? points,
    ActivityStats? stats,
    TrackingPermission? permission,
    DateTime? startedAt,
    String? lastSavedActivityId,
    // Sentinel-free clearing: `copyWith(error: null)` cannot distinguish
    // "leave it" from "clear it", so clearing is an explicit flag.
    bool clearError = false,
    bool clearStartedAt = false,
  }) {
    return RecordingState(
      status: status ?? this.status,
      activityType: activityType ?? this.activityType,
      points: points ?? this.points,
      stats: stats ?? this.stats,
      permission: permission ?? this.permission,
      startedAt: clearStartedAt ? null : (startedAt ?? this.startedAt),
      error: clearError ? null : error,
      lastSavedActivityId: lastSavedActivityId ?? this.lastSavedActivityId,
    );
  }

  RecordingState withError(String message) {
    return RecordingState(
      status: status,
      activityType: activityType,
      points: points,
      stats: stats,
      permission: permission,
      startedAt: startedAt,
      error: message,
      lastSavedActivityId: lastSavedActivityId,
    );
  }
}
