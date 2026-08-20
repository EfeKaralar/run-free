// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_test/flutter_test.dart';
import 'package:run_free/src/domain/models/track_point.dart';
import 'package:run_free/src/domain/services/stats_calculator.dart';

/// One degree of latitude, in metres, for the Earth radius StatsCalculator
/// uses. Handy for building tracks of a known length.
const metersPerDegreeLatitude = 111194.93;

/// Builds a straight north-bound track.
///
/// [spacingMeters] apart and [intervalSeconds] apart, starting at the equator
/// on the prime meridian.
List<TrackPoint> straightTrack({
  required int count,
  double spacingMeters = 10,
  int intervalSeconds = 1,
  double? accuracy = 5,
  double? altitude,
  double? speed,
}) {
  final start = DateTime.utc(2026, 1, 1, 8);
  final deltaLat = spacingMeters / metersPerDegreeLatitude;

  return List.generate(count, (i) {
    return TrackPoint(
      timestamp: start.add(Duration(seconds: i * intervalSeconds)),
      latitude: i * deltaLat,
      longitude: 0,
      accuracy: accuracy,
      altitude: altitude,
      speed: speed,
    );
  });
}

void main() {
  const calculator = StatsCalculator();

  group('haversineMeters', () {
    test('measures a known one-degree separation along a meridian', () {
      final distance = StatsCalculator.haversineMeters(0, 0, 1, 0);
      expect(distance, closeTo(metersPerDegreeLatitude, 1));
    });

    test('is zero for identical points', () {
      expect(StatsCalculator.haversineMeters(51.5, -0.12, 51.5, -0.12), 0);
    });

    test('is symmetric', () {
      final forward = StatsCalculator.haversineMeters(51.5, -0.1, 48.85, 2.35);
      final backward = StatsCalculator.haversineMeters(48.85, 2.35, 51.5, -0.1);
      expect(forward, closeTo(backward, 0.001));
    });

    test('handles crossing the antimeridian without wrapping the long way', () {
      // Two points 0.2 degrees apart either side of the date line.
      final distance = StatsCalculator.haversineMeters(0, 179.9, 0, -179.9);
      expect(distance, closeTo(0.2 * metersPerDegreeLatitude, 50));
    });
  });

  group('compute', () {
    test('returns empty stats for fewer than two points', () {
      expect(calculator.compute(const []).distanceMeters, 0);
      expect(calculator.compute(straightTrack(count: 1)).distanceMeters, 0);
    });

    test('sums distance along a straight track', () {
      // 11 points, 10 gaps of 10 m.
      final stats = calculator.compute(straightTrack(count: 11));
      expect(stats.distanceMeters, closeTo(100, 1));
    });

    test('discards fixes worse than the accuracy threshold', () {
      final points = [
        ...straightTrack(count: 3),
        // A wild fix 1 km east, but flagged as very inaccurate.
        TrackPoint(
          timestamp: DateTime.utc(2026, 1, 1, 8, 0, 3),
          latitude: 0,
          longitude: 0.01,
          accuracy: 500,
        ),
        ...straightTrack(count: 1),
      ];

      final stats = calculator.compute(points);
      // Only the 2 good gaps of 10 m survive; the 1 km excursion is dropped.
      expect(stats.distanceMeters, lessThan(50));
    });

    test('keeps fixes that report no accuracy at all', () {
      // A missing accuracy means the platform did not say, not that it is bad.
      final stats = calculator.compute(
        straightTrack(count: 11, accuracy: null),
      );
      expect(stats.distanceMeters, closeTo(100, 1));
    });

    test('ignores sub-threshold jitter from a stationary device', () {
      // A phone on a table: fixes 0.5 m apart, well under the 2 m gate.
      final stats = calculator.compute(
        straightTrack(count: 60, spacingMeters: 0.5),
      );
      expect(
        stats.distanceMeters,
        0,
        reason: 'a stationary phone must not accumulate distance',
      );
    });

    test('rejects implausibly fast segments as GPS teleports', () {
      final points = [
        ...straightTrack(count: 3),
        // 5 km in one second — a tunnel re-acquisition, not movement.
        TrackPoint(
          timestamp: DateTime.utc(2026, 1, 1, 8, 0, 3),
          latitude: 0.05,
          longitude: 0,
          accuracy: 5,
        ),
      ];

      final stats = calculator.compute(points);
      expect(stats.distanceMeters, closeTo(20, 1));
    });

    test('excludes stopped intervals from moving time', () {
      // Reported speed below the 0.5 m/s threshold: the user is standing still.
      final stopped = straightTrack(count: 11, speed: 0.1);
      expect(calculator.compute(stopped).movingDuration, Duration.zero);

      final running = straightTrack(count: 11, speed: 3);
      expect(calculator.compute(running).movingDuration.inSeconds, 10);
    });

    test('elapsed time is taken from the caller, not the timestamps', () {
      // The controller knows about pauses; the calculator does not.
      final stats = calculator.compute(
        straightTrack(count: 11),
        elapsed: const Duration(minutes: 30),
      );
      expect(stats.elapsedDuration, const Duration(minutes: 30));
    });

    test('flat ground with noisy altitude reports no elevation gain', () {
      final start = DateTime.utc(2026, 1, 1, 8);
      final deltaLat = 10 / metersPerDegreeLatitude;
      // Altitude wobbling +/-1 m, below the 3 m hysteresis threshold.
      final points = List.generate(40, (i) {
        return TrackPoint(
          timestamp: start.add(Duration(seconds: i)),
          latitude: i * deltaLat,
          longitude: 0,
          accuracy: 5,
          altitude: 100 + (i.isEven ? 1 : -1),
        );
      });

      final stats = calculator.compute(points);
      expect(
        stats.elevationGainMeters,
        0,
        reason: 'barometric noise must not accumulate into phantom climb',
      );
    });

    test('a genuine climb is counted', () {
      final start = DateTime.utc(2026, 1, 1, 8);
      final deltaLat = 10 / metersPerDegreeLatitude;
      // Climbing 5 m per fix, comfortably above the threshold.
      final points = List.generate(11, (i) {
        return TrackPoint(
          timestamp: start.add(Duration(seconds: i)),
          latitude: i * deltaLat,
          longitude: 0,
          accuracy: 5,
          altitude: 100 + i * 5,
        );
      });

      final stats = calculator.compute(points);
      expect(stats.elevationGainMeters, closeTo(50, 1));
      expect(stats.elevationLossMeters, 0);
    });

    test('average pace reflects moving time, not elapsed time', () {
      // 1 km covered in 300 s of movement, inside a 600 s elapsed window.
      final stats = calculator
          .compute(
            straightTrack(count: 101, spacingMeters: 10, speed: 3),
            elapsed: const Duration(seconds: 600),
          );

      expect(stats.distanceMeters, closeTo(1000, 5));
      expect(stats.movingDuration.inSeconds, 100);
      // 100 s per ~1 km.
      expect(stats.averagePaceSecondsPerKm, closeTo(100, 2));
    });
  });

  group('computeLaps', () {
    test('splits a 3 km track into three full laps', () {
      // 301 points 10 m apart = 3,000 m.
      final laps = calculator.computeLaps(
        straightTrack(count: 301, spacingMeters: 10),
        splitDistanceMeters: 1000,
      );

      expect(laps.length, 3);
      expect(laps.map((l) => l.index), [1, 2, 3]);
      for (final lap in laps) {
        expect(lap.distanceMeters, closeTo(1000, 1));
      }
    });

    test('includes a trailing partial split', () {
      // 1,500 m: one full km plus a 500 m remainder.
      final laps = calculator.computeLaps(
        straightTrack(count: 151, spacingMeters: 10),
        splitDistanceMeters: 1000,
      );

      expect(laps.length, 2);
      expect(laps.first.distanceMeters, closeTo(1000, 1));
      expect(laps.last.distanceMeters, closeTo(500, 10));
    });

    test('lap durations sum to roughly the tracked time', () {
      final laps = calculator.computeLaps(
        straightTrack(count: 301, spacingMeters: 10),
        splitDistanceMeters: 1000,
      );

      final total = laps.fold(Duration.zero, (sum, l) => sum + l.duration);
      // 300 intervals of one second.
      expect(total.inSeconds, closeTo(300, 2));
    });

    test('returns nothing for a track shorter than one point', () {
      expect(
        calculator.computeLaps(const [], splitDistanceMeters: 1000),
        isEmpty,
      );
    });

    test('mile splits are longer than kilometre splits', () {
      final track = straightTrack(count: 401, spacingMeters: 10);
      final km = calculator.computeLaps(track, splitDistanceMeters: 1000);
      final miles = calculator.computeLaps(track, splitDistanceMeters: 1609.344);

      expect(km.length, greaterThan(miles.length));
    });
  });
}