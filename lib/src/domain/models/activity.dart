// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';

/// A completed, saved activity.
///
/// [stats] are stored denormalised on the row rather than recomputed from
/// [points]: the history list renders hundreds of activities and must not have
/// to load millions of track points to show a distance.
class Activity {
  const Activity({
    required this.id,
    required this.type,
    required this.startedAt,
    required this.endedAt,
    required this.stats,
    this.title,
    this.notes,
    this.points = const [],
    this.laps = const [],
  });

  /// A UUID rather than an autoincrement integer, so that records created on
  /// different devices can be merged without collisions once sync exists.
  final String id;

  final ActivityType type;

  /// Start time in UTC. Convert at the display layer, never in storage.
  final DateTime startedAt;
  final DateTime endedAt;

  final ActivityStats stats;

  /// User-supplied name. Falls back to [defaultTitle] when empty.
  final String? title;
  final String? notes;

  /// Empty unless the activity was loaded with its track. The history list
  /// deliberately loads activities without points.
  final List<TrackPoint> points;
  final List<ActivityLap> laps;

  bool get hasTrack => points.isNotEmpty;

  /// A readable name derived from the time of day, used when the user has not
  /// named the activity themselves.
  String get defaultTitle {
    final local = startedAt.toLocal();
    final partOfDay = switch (local.hour) {
      >= 5 && < 12 => 'Morning',
      >= 12 && < 17 => 'Afternoon',
      >= 17 && < 21 => 'Evening',
      _ => 'Night',
    };
    final date = '${local.day}/${local.month}/${local.year}';
    return '$partOfDay ${type.label} ($date)';
  }

  String get displayTitle {
    final t = title?.trim();
    return (t == null || t.isEmpty) ? defaultTitle : t;
  }

  Activity copyWith({
    String? id,
    ActivityType? type,
    DateTime? startedAt,
    DateTime? endedAt,
    ActivityStats? stats,
    String? title,
    String? notes,
    List<TrackPoint>? points,
    List<ActivityLap>? laps,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      stats: stats ?? this.stats,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      points: points ?? this.points,
      laps: laps ?? this.laps,
    );
  }
}
