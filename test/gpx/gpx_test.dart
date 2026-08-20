// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_test/flutter_test.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';
import 'package:run_free/src/gpx/gpx_reader.dart';
import 'package:run_free/src/gpx/gpx_writer.dart';

import '../domain/stats_calculator_test.dart' show straightTrack;

void main() {
  const writer = GpxWriter();
  const reader = GpxReader();

  Activity buildActivity({
    ActivityType type = ActivityType.run,
    String? title,
    List<TrackPoint>? points,
  }) {
    final track = points ?? straightTrack(count: 11, altitude: 100);
    return Activity(
      id: 'test-id',
      type: type,
      startedAt: track.first.timestamp,
      endedAt: track.last.timestamp,
      title: title,
      stats: const ActivityStats(distanceMeters: 100),
      points: track,
    );
  }

  group('GpxWriter', () {
    test('emits a well-formed GPX 1.1 document', () {
      final xml = writer.write(buildActivity());

      expect(xml, contains('<?xml version="1.0" encoding="UTF-8"?>'));
      expect(xml, contains('version="1.1"'));
      expect(xml, contains('creator="Run Free"'));
      expect(xml, contains('http://www.topografix.com/GPX/1/1'));
      expect(xml, contains('<trkseg>'));
    });

    test('writes one trkpt per track point', () {
      final xml = writer.write(buildActivity());
      expect('<trkpt'.allMatches(xml).length, 11);
    });

    test('writes the sport as a GPX type', () {
      final xml = writer.write(buildActivity(type: ActivityType.ride));
      expect(xml, contains('<type>cycling</type>'));
    });

    test('timestamps are UTC with a trailing Z', () {
      final xml = writer.write(buildActivity());
      expect(xml, contains('<time>2026-01-01T08:00:00Z</time>'));
    });

    test('omits ele when a point has no altitude', () {
      final xml = writer.write(
        buildActivity(points: straightTrack(count: 3)),
      );
      expect(xml, isNot(contains('<ele>')));
    });

    test('builds a filesystem-safe filename', () {
      final name = writer.filenameFor(
        buildActivity(title: 'Morning Run: Regent\'s Park!'),
      );
      expect(name, endsWith('.gpx'));
      expect(name, matches(RegExp(r'^[a-z0-9\-_.]+$')));
    });
  });

  group('GpxReader', () {
    test('round-trips a written activity without losing points', () {
      final original = buildActivity();
      final parsed = reader.parse(writer.write(original));

      expect(parsed.points.length, original.points.length);
      expect(
        parsed.points.first.latitude,
        closeTo(original.points.first.latitude, 0.0000001),
      );
      expect(
        parsed.points.last.longitude,
        closeTo(original.points.last.longitude, 0.0000001),
      );
      expect(parsed.points.first.timestamp, original.points.first.timestamp);
    });

    test('round-trips the sport', () {
      for (final type in ActivityType.values) {
        final parsed = reader.parse(writer.write(buildActivity(type: type)));
        expect(parsed.type, type, reason: '${type.name} should survive');
      }
    });

    test('recomputes distance from the imported track', () {
      final parsed = reader.parse(writer.write(buildActivity()));
      expect(parsed.stats.distanceMeters, closeTo(100, 2));
    });

    test('parses files that bind GPX to a namespace prefix', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx:gpx xmlns:gpx="http://www.topografix.com/GPX/1/1" version="1.1">
  <gpx:trk>
    <gpx:trkseg>
      <gpx:trkpt lat="51.5" lon="-0.12">
        <gpx:time>2026-01-01T08:00:00Z</gpx:time>
      </gpx:trkpt>
      <gpx:trkpt lat="51.5001" lon="-0.12">
        <gpx:time>2026-01-01T08:00:10Z</gpx:time>
      </gpx:trkpt>
    </gpx:trkseg>
  </gpx:trk>
</gpx:gpx>
''';
      final parsed = reader.parse(xml);
      expect(parsed.points.length, 2);
    });

    test('merges multiple track segments into one activity', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">
  <trk>
    <trkseg>
      <trkpt lat="51.5000" lon="0"><time>2026-01-01T08:00:00Z</time></trkpt>
      <trkpt lat="51.5001" lon="0"><time>2026-01-01T08:00:10Z</time></trkpt>
    </trkseg>
    <trkseg>
      <trkpt lat="51.5002" lon="0"><time>2026-01-01T08:00:20Z</time></trkpt>
    </trkseg>
  </trk>
</gpx>
''';
      expect(reader.parse(xml).points.length, 3);
    });

    test('orders points by time even when the file does not', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">
  <trk><trkseg>
    <trkpt lat="51.5002" lon="0"><time>2026-01-01T08:00:20Z</time></trkpt>
    <trkpt lat="51.5000" lon="0"><time>2026-01-01T08:00:00Z</time></trkpt>
    <trkpt lat="51.5001" lon="0"><time>2026-01-01T08:00:10Z</time></trkpt>
  </trkseg></trk>
</gpx>
''';
      final points = reader.parse(xml).points;
      expect(
        points.map((p) => p.timestamp),
        [
          DateTime.utc(2026, 1, 1, 8, 0, 0),
          DateTime.utc(2026, 1, 1, 8, 0, 10),
          DateTime.utc(2026, 1, 1, 8, 0, 20),
        ],
      );
    });

    test('rejects a file with no track points', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">
  <wpt lat="51.5" lon="-0.12"><name>A waypoint</name></wpt>
</gpx>
''';
      expect(
        () => reader.parse(xml),
        throwsA(isA<GpxParseException>()),
      );
    });

    test('rejects malformed XML with a readable message', () {
      expect(
        () => reader.parse('this is not xml at all'),
        throwsA(isA<GpxParseException>()),
      );
    });

    test('drops points with no timestamp rather than inventing one', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">
  <trk><trkseg>
    <trkpt lat="51.5000" lon="0"><time>2026-01-01T08:00:00Z</time></trkpt>
    <trkpt lat="51.5001" lon="0"/>
    <trkpt lat="51.5002" lon="0"><time>2026-01-01T08:00:20Z</time></trkpt>
  </trkseg></trk>
</gpx>
''';
      expect(reader.parse(xml).points.length, 2);
    });

    test('drops points with out-of-range coordinates', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">
  <trk><trkseg>
    <trkpt lat="51.5000" lon="0"><time>2026-01-01T08:00:00Z</time></trkpt>
    <trkpt lat="999" lon="0"><time>2026-01-01T08:00:10Z</time></trkpt>
    <trkpt lat="51.5002" lon="0"><time>2026-01-01T08:00:20Z</time></trkpt>
  </trkseg></trk>
</gpx>
''';
      expect(reader.parse(xml).points.length, 2);
    });

    test('falls back to the supplied sport when the file declares none', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">
  <trk><trkseg>
    <trkpt lat="51.5000" lon="0"><time>2026-01-01T08:00:00Z</time></trkpt>
    <trkpt lat="51.5001" lon="0"><time>2026-01-01T08:00:10Z</time></trkpt>
  </trkseg></trk>
</gpx>
''';
      final parsed = reader.parse(xml, fallbackType: ActivityType.hike);
      expect(parsed.type, ActivityType.hike);
    });

    test('recognises varied sport labels from other exporters', () {
      String withType(String type) =>
          '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">
  <trk>
    <type>$type</type>
    <trkseg>
      <trkpt lat="51.5000" lon="0"><time>2026-01-01T08:00:00Z</time></trkpt>
      <trkpt lat="51.5001" lon="0"><time>2026-01-01T08:00:10Z</time></trkpt>
    </trkseg>
  </trk>
</gpx>
''';

      expect(reader.parse(withType('Running')).type, ActivityType.run);
      expect(reader.parse(withType('jogging')).type, ActivityType.run);
      expect(reader.parse(withType('Ride')).type, ActivityType.ride);
      expect(reader.parse(withType('biking')).type, ActivityType.ride);
      expect(reader.parse(withType('Trekking')).type, ActivityType.hike);
      expect(reader.parse(withType('Walking')).type, ActivityType.walk);
    });
  });
}