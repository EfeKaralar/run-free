// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_test/flutter_test.dart';
import 'package:run_free/src/core/formatters.dart';
import 'package:run_free/src/core/units.dart';

void main() {
  const metric = Formatters(UnitSystem.metric);
  const imperial = Formatters(UnitSystem.imperial);

  group('duration', () {
    test('drops the hour component below an hour', () {
      expect(
        Formatters.duration(const Duration(minutes: 23, seconds: 45)),
        '23:45',
      );
    });

    test('includes hours once past one', () {
      expect(
        Formatters.duration(const Duration(hours: 1, minutes: 23, seconds: 45)),
        '1:23:45',
      );
    });

    test('pads seconds and minutes', () {
      expect(Formatters.duration(const Duration(seconds: 5)), '0:05');
      expect(
        Formatters.duration(const Duration(hours: 2, minutes: 3, seconds: 4)),
        '2:03:04',
      );
    });

    test('zero is not blank', () {
      expect(Formatters.duration(Duration.zero), '0:00');
    });
  });

  group('distance', () {
    test('uses metres below one kilometre', () {
      expect(metric.distance(420), '420 m');
    });

    test('uses kilometres with two decimals above one', () {
      expect(metric.distance(5023), '5.02 km');
    });

    test('converts to miles', () {
      // 5 km is a little over 3.1 miles.
      expect(imperial.distance(5000), '3.11 mi');
    });
  });

  group('pace', () {
    test('formats as minutes and seconds per kilometre', () {
      expect(metric.pace(305), '5:05 /km');
    });

    test('rolls over instead of printing sixty seconds', () {
      // 299.6 s rounds to 300, which must read 5:00 and never 4:60.
      expect(metric.pace(299.6), '5:00 /km');
    });

    test('converts to per-mile', () {
      // 5:00/km is roughly 8:03/mi.
      expect(imperial.pace(300), '8:03 /mi');
    });

    test('shows a dash rather than zero when there is no pace', () {
      // A stopped runner has no pace; 0:00 would imply infinite speed.
      expect(metric.pace(null), '—');
      expect(metric.pace(0), '—');
      expect(metric.pace(double.infinity), '—');
    });

    test('shows a dash for implausibly slow paces', () {
      expect(metric.pace(7200), '—');
    });
  });

  group('speed', () {
    test('converts metres per second to km/h', () {
      expect(metric.speed(10), '36.0 km/h');
    });

    test('converts metres per second to mph', () {
      expect(imperial.speed(10), '22.4 mph');
    });
  });

  group('elevation', () {
    test('reports metres', () {
      expect(metric.elevation(142.6), '143 m');
    });

    test('converts to feet', () {
      expect(imperial.elevation(100), '328 ft');
    });
  });

  group('fileTimestamp', () {
    test('is filesystem-safe', () {
      final stamp = Formatters.fileTimestamp(DateTime.utc(2026, 8, 12, 7, 14));
      expect(stamp, matches(RegExp(r'^\d{4}-\d{2}-\d{2}_\d{6}$')));
    });
  });
}
