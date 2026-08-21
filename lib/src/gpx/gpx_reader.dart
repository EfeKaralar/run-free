// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';
import 'package:run_free/src/domain/services/stats_calculator.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

/// Raised when a file is not usable GPX. Carries a message intended to be shown
/// to the user, not logged.
class GpxParseException implements Exception {
  const GpxParseException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Parses GPX into an [Activity].
///
/// Written defensively. Real-world GPX is a swamp: files from watches, phones
/// and websites disagree about namespaces, use GPX 1.0 or 1.1, sometimes omit
/// timestamps entirely, and often split a single ride across many `<trkseg>`
/// elements. Anything that can be salvaged is.
class GpxReader {
  const GpxReader({
    this.calculator = const StatsCalculator(),
    this.uuid = const Uuid(),
  });

  final StatsCalculator calculator;
  final Uuid uuid;

  /// Parses [xmlString], defaulting the sport to [fallbackType] when the file
  /// does not declare one.
  Activity parse(
    String xmlString, {
    ActivityType fallbackType = ActivityType.run,
    double splitDistanceMeters = 1000,
  }) {
    final XmlDocument document;
    try {
      document = XmlDocument.parse(xmlString);
    } on XmlException catch (error) {
      throw GpxParseException('This file is not valid XML: ${error.message}');
    }

    final points = <TrackPoint>[];

    // Matched by local name so files that bind GPX to a prefix
    // (`<gpx:trkpt>`) parse identically to ones using a default namespace.
    for (final node in _byLocalName(document, 'trkpt')) {
      final point = _parsePoint(node);
      if (point != null) points.add(point);
    }

    if (points.isEmpty) {
      throw const GpxParseException(
        'No track points found. Route-only GPX files (<rte>) and waypoint '
        'files are not activities, so there is nothing to import.',
      );
    }

    // Multiple segments arrive in document order, but a file merged by hand can
    // interleave them. Sorting makes distance and pace correct either way.
    points.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final type = _parseType(document) ?? fallbackType;
    final name = _firstText(document, 'name');

    final startedAt = points.first.timestamp;
    final endedAt = points.last.timestamp;

    final stats = calculator.compute(
      points,
      elapsed: endedAt.difference(startedAt),
    );

    return Activity(
      id: uuid.v4(),
      type: type,
      startedAt: startedAt,
      endedAt: endedAt,
      title: name,
      stats: stats,
      points: points,
      laps: calculator.computeLaps(
        points,
        splitDistanceMeters: splitDistanceMeters,
      ),
    );
  }

  TrackPoint? _parsePoint(XmlElement node) {
    final lat = double.tryParse(node.getAttribute('lat') ?? '');
    final lon = double.tryParse(node.getAttribute('lon') ?? '');
    // A point without coordinates is not a point.
    if (lat == null || lon == null) return null;
    if (lat.abs() > 90 || lon.abs() > 180) return null;

    final timeText = _childText(node, 'time');
    final timestamp = timeText == null ? null : DateTime.tryParse(timeText);
    if (timestamp == null) {
      // Without time there is no pace, no moving time, and no way to order the
      // track. Importing such a file as an "activity" would produce numbers
      // that are simply wrong, so the point is dropped.
      return null;
    }

    final eleText = _childText(node, 'ele');

    return TrackPoint(
      timestamp: timestamp.toUtc(),
      latitude: lat,
      longitude: lon,
      altitude: eleText == null ? null : double.tryParse(eleText),
      // GPX carries no speed or accuracy in its base schema. Leaving these null
      // makes StatsCalculator derive speed from the track instead of trusting a
      // value that was never recorded.
    );
  }

  ActivityType? _parseType(XmlDocument document) {
    final raw = _firstText(document, 'type')?.toLowerCase().trim();
    if (raw == null || raw.isEmpty) return null;

    // Matched loosely: exporters write "running", "Run", "9" (Strava's
    // numeric codes), "cycling", "Ride" and more.
    if (raw.contains('run') || raw.contains('jog')) return ActivityType.run;
    if (raw.contains('cycl') ||
        raw.contains('bike') ||
        raw.contains('ride') ||
        raw.contains('biking')) {
      return ActivityType.ride;
    }
    if (raw.contains('hik') || raw.contains('trek')) return ActivityType.hike;
    if (raw.contains('walk')) return ActivityType.walk;
    return null;
  }

  Iterable<XmlElement> _byLocalName(XmlDocument document, String localName) {
    return document.descendants.whereType<XmlElement>().where(
      (e) => e.name.local == localName,
    );
  }

  String? _childText(XmlElement parent, String localName) {
    for (final child in parent.childElements) {
      if (child.name.local == localName) {
        final text = child.innerText.trim();
        return text.isEmpty ? null : text;
      }
    }
    return null;
  }

  String? _firstText(XmlDocument document, String localName) {
    for (final element in _byLocalName(document, localName)) {
      final text = element.innerText.trim();
      if (text.isNotEmpty) return text;
    }
    return null;
  }
}
