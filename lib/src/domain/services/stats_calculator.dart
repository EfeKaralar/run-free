// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'dart:math' as math;

import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/track_point.dart';

/// Derives distance, time, elevation and splits from a list of track points.
///
/// Every method here is a pure function of its inputs. That is deliberate:
/// these are the calculations users will compare against other apps and
/// complain about, so they need to be unit-testable without a device, a
/// database, or a running Flutter engine.
///
/// The default thresholds exist because raw GPS lies. A phone sitting on a
/// table still emits fixes that wander several metres, and naively summing the
/// distance between consecutive fixes will happily report a 400 m "run" from a
/// device that never moved.
class StatsCalculator {
  const StatsCalculator({
    this.maxAccuracyMeters = 30,
    this.minDistanceDeltaMeters = 2.0,
    this.movingSpeedThresholdMetersPerSecond = 0.5,
    this.elevationThresholdMeters = 3.0,
    this.maxPlausibleSpeedMetersPerSecond = 30.0,
  });

  /// Fixes with a worse (larger) accuracy radius than this are ignored.
  /// 30 m keeps urban-canyon fixes while dropping cell-tower fallbacks.
  final double maxAccuracyMeters;

  /// Movement below this between two fixes is treated as GPS jitter and
  /// contributes no distance.
  final double minDistanceDeltaMeters;

  /// Below this speed the user is considered stopped, so the interval does not
  /// count toward moving time. 0.5 m/s is a slow walk.
  final double movingSpeedThresholdMetersPerSecond;

  /// Elevation must change by more than this from the last committed reference
  /// before it counts as gain or loss. Without hysteresis, barometric noise
  /// alone reports hundreds of metres of climb on a flat route.
  final double elevationThresholdMeters;

  /// Segments implying a speed above this are discarded as GPS teleports
  /// (tunnel re-acquisition, cold-start fixes). 30 m/s is ~108 km/h.
  final double maxPlausibleSpeedMetersPerSecond;

  static const double _earthRadiusMeters = 6371008.8;

  /// Great-circle distance between two coordinates, in metres.
  ///
  /// Haversine rather than a projected approximation: it stays accurate near
  /// the poles and across the antimeridian, and the cost is irrelevant at the
  /// one-fix-per-second rate we actually sample at.
  static double haversineMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final phi1 = _toRadians(lat1);
    final phi2 = _toRadians(lat2);
    final deltaPhi = _toRadians(lat2 - lat1);
    final deltaLambda = _toRadians(lon2 - lon1);

    final a =
        math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);

    return _earthRadiusMeters * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180.0;

  /// Drops fixes too inaccurate to trust.
  ///
  /// Points with no reported accuracy are kept: a missing value means the
  /// platform did not say, not that the fix is bad.
  List<TrackPoint> filterByAccuracy(List<TrackPoint> points) {
    return points
        .where((p) => p.accuracy == null || p.accuracy! <= maxAccuracyMeters)
        .toList(growable: false);
  }

  /// Computes aggregate stats over an already-recorded track.
  ///
  /// [elapsed] is passed in rather than derived from the first and last
  /// timestamps because a paused activity has wall-clock gaps that should not
  /// count. The recording controller knows the true elapsed time; this function
  /// does not.
  ActivityStats compute(List<TrackPoint> points, {Duration? elapsed}) {
    // TODO: Consider rewriting this function using better coding practices, 
    // such as breaking it into smaller functions or using more descriptive variable names. 
    // This would improve readability and maintainability.
    final usable = filterByAccuracy(points);
    if (usable.length < 2) {
      return ActivityStats(
        elapsedDuration: elapsed ?? Duration.zero,
        movingDuration: Duration.zero,
      );
    }

    var distance = 0.0;
    var movingMillis = 0;
    var gain = 0.0;
    var loss = 0.0;
    var maxSpeed = 0.0;

    // Reference altitude for hysteresis, not simply the previous altitude.
    double? elevationReference = usable.first.altitude;

    for (var i = 1; i < usable.length; i++) {
      final prev = usable[i - 1];
      final curr = usable[i];

      final deltaMillis = curr.timestamp
          .difference(prev.timestamp)
          .inMilliseconds;
      // Non-monotonic timestamps happen when the platform replays a queued
      // fix. Skip rather than trust them.
      if (deltaMillis <= 0) continue;

      final segment = haversineMeters(
        prev.latitude,
        prev.longitude,
        curr.latitude,
        curr.longitude,
      );

      final impliedSpeed = segment / (deltaMillis / 1000.0);
      if (impliedSpeed > maxPlausibleSpeedMetersPerSecond) {
        // A teleport. Contributes no distance, but the clock still ran.
        continue;
      }

      if (segment >= minDistanceDeltaMeters) {
        distance += segment;
      }

      // Prefer the platform's Doppler-derived speed; fall back to the
      // segment-derived value when it is absent.
      final speed = curr.speed ?? impliedSpeed;
      if (speed > maxSpeed && speed <= maxPlausibleSpeedMetersPerSecond) {
        maxSpeed = speed;
      }
      if (speed >= movingSpeedThresholdMetersPerSecond) {
        movingMillis += deltaMillis;
      }

      final altitude = curr.altitude;
      if (altitude != null) {
        if (elevationReference == null) {
          elevationReference = altitude;
        } else {
          final delta = altitude - elevationReference;
          if (delta.abs() > elevationThresholdMeters) {
            if (delta > 0) {
              gain += delta;
            } else {
              loss += -delta;
            }
            elevationReference = altitude;
          }
        }
      }
    }

    return ActivityStats(
      distanceMeters: distance,
      movingDuration: Duration(milliseconds: movingMillis),
      elapsedDuration:
          elapsed ??
          usable.last.timestamp.difference(usable.first.timestamp),
      elevationGainMeters: gain,
      elevationLossMeters: loss,
      maxSpeedMetersPerSecond: maxSpeed,
    );
  }

  /// Splits the track into fixed-distance laps (1 km or 1 mile).
  ///
  /// The final partial split is included, because a runner who stops at 7.4 km
  /// still wants to see that last 400 m. Its pace is extrapolated from a short
  /// distance and so is noisier; the UI marks it as partial.
  List<ActivityLap> computeLaps(
    List<TrackPoint> points, {
    required double splitDistanceMeters,
  }) {
    // TODO: Consider rewriting this function using better coding practices,
    // such as breaking it into smaller functions or using more descriptive variable names.
    final usable = filterByAccuracy(points);
    if (usable.length < 2 || splitDistanceMeters <= 0) return const [];

    final laps = <ActivityLap>[];
    var lapIndex = 1;
    var lapDistance = 0.0;
    var lapMillis = 0;
    var lapGain = 0.0;
    double? elevationReference = usable.first.altitude;

    for (var i = 1; i < usable.length; i++) {
      final prev = usable[i - 1];
      final curr = usable[i];

      final deltaMillis = curr.timestamp
          .difference(prev.timestamp)
          .inMilliseconds;
      if (deltaMillis <= 0) continue;

      final segment = haversineMeters(
        prev.latitude,
        prev.longitude,
        curr.latitude,
        curr.longitude,
      );
      if (segment / (deltaMillis / 1000.0) > maxPlausibleSpeedMetersPerSecond) {
        continue;
      }

      lapDistance += segment >= minDistanceDeltaMeters ? segment : 0;
      lapMillis += deltaMillis;

      final altitude = curr.altitude;
      if (altitude != null) {
        if (elevationReference == null) {
          elevationReference = altitude;
        } else {
          final delta = altitude - elevationReference;
          if (delta.abs() > elevationThresholdMeters) {
            if (delta > 0) lapGain += delta;
            elevationReference = altitude;
          }
        }
      }

      // A single segment can overshoot the split boundary. Attribute time
      // proportionally to the part of the segment that fell inside the lap,
      // otherwise long GPS gaps skew a split's pace badly.
      while (lapDistance >= splitDistanceMeters) {
        final overshoot = lapDistance - splitDistanceMeters;
        final fractionInsideLap = segment > 0
            ? ((segment - overshoot) / segment).clamp(0.0, 1.0)
            : 1.0;
        final millisInsideLap = (lapMillis - deltaMillis) +
            (deltaMillis * fractionInsideLap).round();

        laps.add(
          ActivityLap(
            index: lapIndex++,
            distanceMeters: splitDistanceMeters,
            duration: Duration(milliseconds: math.max(0, millisInsideLap)),
            elevationGainMeters: lapGain,
          ),
        );

        lapDistance = overshoot;
        lapMillis -= millisInsideLap;
        lapGain = 0;
      }
    }

    // Trailing partial split.
    if (lapDistance > 1.0) {
      laps.add(
        ActivityLap(
          index: lapIndex,
          distanceMeters: lapDistance,
          duration: Duration(milliseconds: math.max(0, lapMillis)),
          elevationGainMeters: lapGain,
        ),
      );
    }

    return laps;
  }
}