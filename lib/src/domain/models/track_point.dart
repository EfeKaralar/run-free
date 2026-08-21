// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:latlong2/latlong.dart';

/// A single recorded GPS fix belonging to an activity.
///
/// This is the app's own model, deliberately independent of Tracelet's
/// `Location` and of Drift's generated row classes. Everything upstream of the
/// repository speaks this type, which is what makes it possible to swap the
/// storage layer (or wrap it in encryption) without touching the UI.
class TrackPoint {
  const TrackPoint({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speed,
    this.accuracy,
    this.heading,
  });

  /// When the fix was taken, in UTC.
  final DateTime timestamp;

  final double latitude;
  final double longitude;

  /// Metres above sea level, if the platform reported it.
  final double? altitude;

  /// Ground speed in metres per second, as reported by the platform.
  ///
  /// Preferred over deriving speed from consecutive points: the platform value
  /// comes from Doppler shift on most devices and is far less noisy.
  final double? speed;

  /// Horizontal accuracy radius in metres. Larger is worse.
  final double? accuracy;

  /// Direction of travel in degrees clockwise from true north.
  final double? heading;

  LatLng get latLng => LatLng(latitude, longitude);

  @override
  String toString() =>
      'TrackPoint($latitude, $longitude @ ${timestamp.toIso8601String()})';
}
