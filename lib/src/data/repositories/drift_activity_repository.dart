// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:drift/drift.dart';
import 'package:run_free/src/data/database/database.dart';
import 'package:run_free/src/data/repositories/activity_repository.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/models/track_point.dart';

/// SQLite-backed [ActivityRepository].
///
/// All translation between Drift row classes and the domain model happens
/// here, and nowhere else. Rows never escape this file.
class DriftActivityRepository implements ActivityRepository {
  DriftActivityRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Activity>> watchActivities() {
    final query = _db.select(_db.activities)
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    return query.watch().map(
      (rows) => rows.map(_activityFromRow).toList(growable: false),
    );
  }

  @override
  Stream<Activity?> watchActivity(String id) {
    final query = _db.select(_db.activities)..where((t) => t.id.equals(id));

    // switchMap-style composition without an extra dependency: the outer stream
    // fires on activity changes, and each emission re-reads the track. Tracks
    // are immutable once saved, so this is not as wasteful as it looks.
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      return _hydrate(row);
    });
  }

  @override
  Future<Activity?> getActivity(String id) async {
    final row = await (_db.select(
      _db.activities,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _hydrate(row);
  }

  @override
  Future<void> saveActivity(Activity activity) {
    // One transaction: an activity whose track failed to write halfway is a
    // corrupt record, and the user has no way to recover the missing half.
    return _db.transaction(() async {
      await _db.into(_db.activities).insert(_rowFromActivity(activity));

      if (activity.points.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.trackPoints,
            activity.points.map(
              (p) => TrackPointsCompanion.insert(
                activityId: activity.id,
                timestamp: p.timestamp,
                latitude: p.latitude,
                longitude: p.longitude,
                altitude: Value(p.altitude),
                speed: Value(p.speed),
                accuracy: Value(p.accuracy),
                heading: Value(p.heading),
              ),
            ),
          );
        });
      }

      if (activity.laps.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(
            _db.laps,
            activity.laps.map(
              (l) => LapsCompanion.insert(
                activityId: activity.id,
                lapIndex: l.index,
                distanceMeters: l.distanceMeters,
                durationSeconds: l.duration.inSeconds,
                elevationGainMeters: Value(l.elevationGainMeters),
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Future<void> updateActivityDetails({
    required String id,
    String? title,
    String? notes,
  }) {
    return (_db.update(_db.activities)..where((t) => t.id.equals(id))).write(
      ActivitiesCompanion(title: Value(title), notes: Value(notes)),
    );
  }

  @override
  Future<void> deleteActivity(String id) {
    // Track points and laps go with it via ON DELETE CASCADE, which is only
    // armed because `PRAGMA foreign_keys = ON` runs in beforeOpen.
    return (_db.delete(_db.activities)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<int> countActivities() async {
    final countExp = _db.activities.id.count();
    final query = _db.selectOnly(_db.activities)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<Activity> _hydrate(ActivityRow row) async {
    final pointRows =
        await (_db.select(_db.trackPoints)
              ..where((t) => t.activityId.equals(row.id))
              ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
            .get();

    final lapRows =
        await (_db.select(_db.laps)
              ..where((t) => t.activityId.equals(row.id))
              ..orderBy([(t) => OrderingTerm.asc(t.lapIndex)]))
            .get();

    return _activityFromRow(row).copyWith(
      points: pointRows
          .map(
            (p) => TrackPoint(
              timestamp: p.timestamp,
              latitude: p.latitude,
              longitude: p.longitude,
              altitude: p.altitude,
              speed: p.speed,
              accuracy: p.accuracy,
              heading: p.heading,
            ),
          )
          .toList(growable: false),
      laps: lapRows
          .map(
            (l) => ActivityLap(
              index: l.lapIndex,
              distanceMeters: l.distanceMeters,
              duration: Duration(seconds: l.durationSeconds),
              elevationGainMeters: l.elevationGainMeters,
            ),
          )
          .toList(growable: false),
    );
  }

  Activity _activityFromRow(ActivityRow row) {
    return Activity(
      id: row.id,
      type: ActivityType.fromName(row.type),
      startedAt: row.startedAt,
      endedAt: row.endedAt,
      title: row.title,
      notes: row.notes,
      stats: ActivityStats(
        distanceMeters: row.distanceMeters,
        movingDuration: Duration(seconds: row.movingSeconds),
        elapsedDuration: Duration(seconds: row.elapsedSeconds),
        elevationGainMeters: row.elevationGainMeters,
        elevationLossMeters: row.elevationLossMeters,
        maxSpeedMetersPerSecond: row.maxSpeedMetersPerSecond,
      ),
    );
  }

  ActivitiesCompanion _rowFromActivity(Activity activity) {
    return ActivitiesCompanion.insert(
      id: activity.id,
      type: activity.type.name,
      startedAt: activity.startedAt,
      endedAt: activity.endedAt,
      title: Value(activity.title),
      notes: Value(activity.notes),
      distanceMeters: Value(activity.stats.distanceMeters),
      movingSeconds: Value(activity.stats.movingDuration.inSeconds),
      elapsedSeconds: Value(activity.stats.elapsedDuration.inSeconds),
      elevationGainMeters: Value(activity.stats.elevationGainMeters),
      elevationLossMeters: Value(activity.stats.elevationLossMeters),
      maxSpeedMetersPerSecond: Value(activity.stats.maxSpeedMetersPerSecond),
    );
  }
}
