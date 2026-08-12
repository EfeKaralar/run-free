// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

/// The kind of activity being recorded.
///
/// Stored by [name], never by index, so reordering this enum cannot silently
/// rewrite the meaning of rows already on disk.
enum ActivityType {
  run(label: 'Run', icon: Icons.directions_run, gpxType: 'running'),
  ride(label: 'Ride', icon: Icons.directions_bike, gpxType: 'cycling'),
  walk(label: 'Walk', icon: Icons.directions_walk, gpxType: 'walking'),
  hike(label: 'Hike', icon: Icons.terrain, gpxType: 'hiking');

  const ActivityType({
    required this.label,
    required this.icon,
    required this.gpxType,
  });

  final String label;
  final IconData icon;

  /// Value written to the GPX `<type>` element.
  final String gpxType;

  /// Resolves a stored name back to a type, falling back to [run] for values
  /// written by a newer version of the app.
  static ActivityType fromName(String name) {
    return ActivityType.values.firstWhere(
      (t) => t.name == name,
      orElse: () => ActivityType.run,
    );
  }

  /// Whether pace (time per distance) reads more naturally than speed.
  ///
  /// Runners think in min/km; cyclists think in km/h.
  bool get prefersPaceOverSpeed => this != ActivityType.ride;
}
