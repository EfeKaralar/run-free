// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:run_free/src/domain/models/activity.dart';
import 'package:xml/xml.dart';

/// Serialises an [Activity] to GPX 1.1.
///
/// GPX rather than a bespoke format because the point of exporting is that the
/// file opens in something else — Strava, Garmin Connect, OsmAnd, GPXSee all
/// read this. Data portability is not a feature to bolt on later; it is the
/// reason a user can trust a tracker with their history.
class GpxWriter {
  const GpxWriter();

  static const _gpxNamespace = 'http://www.topografix.com/GPX/1/1';
  static const _xsiNamespace = 'http://www.w3.org/2001/XMLSchema-instance';
  static const _schemaLocation =
      'http://www.topografix.com/GPX/1/1 '
      'http://www.topografix.com/GPX/1/1/gpx.xsd';

  /// Returns the GPX document as a pretty-printed string.
  ///
  /// Pretty-printed on purpose: these files get opened in text editors and
  /// diffed by people checking their own data.
  String write(Activity activity) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element(
      'gpx',
      attributes: {
        'version': '1.1',
        'creator': 'Run Free',
        'xmlns': _gpxNamespace,
        'xmlns:xsi': _xsiNamespace,
        'xsi:schemaLocation': _schemaLocation,
      },
      nest: () {
        builder.element(
          'metadata',
          nest: () {
            builder.element('name', nest: activity.displayTitle);
            builder.element('time', nest: _iso(activity.startedAt));
          },
        );

        builder.element(
          'trk',
          nest: () {
            builder.element('name', nest: activity.displayTitle);
            builder.element('type', nest: activity.type.gpxType);

            final notes = activity.notes?.trim();
            if (notes != null && notes.isNotEmpty) {
              builder.element('desc', nest: notes);
            }

            builder.element(
              'trkseg',
              nest: () {
                for (final point in activity.points) {
                  builder.element(
                    'trkpt',
                    attributes: {
                      // Seven decimals is ~1 cm — far beyond GPS precision, but
                      // it round-trips without the file itself losing anything.
                      'lat': point.latitude.toStringAsFixed(7),
                      'lon': point.longitude.toStringAsFixed(7),
                    },
                    nest: () {
                      final altitude = point.altitude;
                      if (altitude != null) {
                        builder.element(
                          'ele',
                          nest: altitude.toStringAsFixed(2),
                        );
                      }
                      builder.element('time', nest: _iso(point.timestamp));
                    },
                  );
                }
              },
            );
          },
        );
      },
    );

    return builder.buildDocument().toXmlString(pretty: true, indent: '  ');
  }

  /// GPX requires UTC timestamps with a trailing `Z`.
  String _iso(DateTime time) =>
      '${time.toUtc().toIso8601String().split('.').first}Z';

  /// A filesystem-safe filename for this activity.
  String filenameFor(Activity activity) {
    final slug = activity.displayTitle
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final date = activity.startedAt.toLocal();
    final stamp =
        '${date.year}-${_two(date.month)}-${_two(date.day)}'
        '_${_two(date.hour)}${_two(date.minute)}';
    return '${slug.isEmpty ? 'activity' : slug}_$stamp.gpx';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
