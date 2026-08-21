// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

/// Aggregate numbers derived from an activity's track points.
///
/// Held separately from [Activity] because these are also computed live during
/// recording, before any activity row exists.
class ActivityStats {
  const ActivityStats({
    this.distanceMeters = 0,
    this.movingDuration = Duration.zero,
    this.elapsedDuration = Duration.zero,
    this.elevationGainMeters = 0,
    this.elevationLossMeters = 0,
    this.maxSpeedMetersPerSecond = 0,
  });

  static const empty = ActivityStats();

  final double distanceMeters;

  /// Time spent actually moving, excluding stops at traffic lights and so on.
  final Duration movingDuration;

  /// Wall-clock time from start to finish, including pauses.
  final Duration elapsedDuration;

  final double elevationGainMeters;
  final double elevationLossMeters;
  final double maxSpeedMetersPerSecond;

  /// Average speed over moving time, in metres per second.
  ///
  /// Moving time rather than elapsed time is the convention every other
  /// tracking app uses, and it is what makes pace comparable between runs.
  double get averageSpeedMetersPerSecond {
    final seconds = movingDuration.inMilliseconds / 1000.0;
    if (seconds <= 0) return 0;
    return distanceMeters / seconds;
  }

  /// Average pace as seconds per kilometre, or `null` when not yet meaningful.
  double? get averagePaceSecondsPerKm {
    if (distanceMeters < 1) return null;
    final seconds = movingDuration.inMilliseconds / 1000.0;
    if (seconds <= 0) return null;
    return seconds / (distanceMeters / 1000.0);
  }

  ActivityStats copyWith({
    double? distanceMeters,
    Duration? movingDuration,
    Duration? elapsedDuration,
    double? elevationGainMeters,
    double? elevationLossMeters,
    double? maxSpeedMetersPerSecond,
  }) {
    return ActivityStats(
      distanceMeters: distanceMeters ?? this.distanceMeters,
      movingDuration: movingDuration ?? this.movingDuration,
      elapsedDuration: elapsedDuration ?? this.elapsedDuration,
      elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
      elevationLossMeters: elevationLossMeters ?? this.elevationLossMeters,
      maxSpeedMetersPerSecond:
          maxSpeedMetersPerSecond ?? this.maxSpeedMetersPerSecond,
    );
  }
}

/// One completed distance split (a "lap") within an activity.
class ActivityLap {
  const ActivityLap({
    required this.index,
    required this.distanceMeters,
    required this.duration,
    required this.elevationGainMeters,
  });

  /// 1-based position of this split within the activity.
  final int index;

  final double distanceMeters;
  final Duration duration;
  final double elevationGainMeters;

  /// Pace for this split alone, in seconds per kilometre.
  double? get paceSecondsPerKm {
    if (distanceMeters < 1) return null;
    return (duration.inMilliseconds / 1000.0) / (distanceMeters / 1000.0);
  }
}
