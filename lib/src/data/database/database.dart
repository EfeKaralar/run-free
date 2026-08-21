// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Saved activities. One row per recorded session.
///
/// Summary statistics are stored on the row rather than recomputed from
/// [TrackPoints]: rendering the history list must not require reading the
/// track.
@DataClassName('ActivityRow')
class Activities extends Table {
  /// UUID, so activities created on separate devices merge cleanly when sync
  /// arrives.
  TextColumn get id => text()();

  /// [ActivityType.name]. Stored as text so enum reordering is harmless.
  TextColumn get type => text()();

  /// UTC. Drift stores DateTime as a Unix timestamp in seconds by default.
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  TextColumn get title => text().nullable()();
  TextColumn get notes => text().nullable()();

  RealColumn get distanceMeters => real().withDefault(const Constant(0))();
  IntColumn get movingSeconds => integer().withDefault(const Constant(0))();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();
  RealColumn get elevationGainMeters => real().withDefault(const Constant(0))();
  RealColumn get elevationLossMeters => real().withDefault(const Constant(0))();
  RealColumn get maxSpeedMetersPerSecond =>
      real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// The recorded GPS track. By far the largest table — a one-hour run at 1 Hz is
/// ~3,600 rows.
@DataClassName('TrackPointRow')
class TrackPoints extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Deleting an activity must take its track with it, hence the cascade.
  TextColumn get activityId =>
      text().references(Activities, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get timestamp => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitude => real().nullable()();
  RealColumn get speed => real().nullable()();
  RealColumn get accuracy => real().nullable()();
  RealColumn get heading => real().nullable()();
}

/// Distance splits, precomputed at save time so the detail screen does not
/// recalculate them on every open.
@DataClassName('LapRow')
class Laps extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get activityId =>
      text().references(Activities, #id, onDelete: KeyAction.cascade)();

  IntColumn get lapIndex => integer()();
  RealColumn get distanceMeters => real()();
  IntColumn get durationSeconds => integer()();
  RealColumn get elevationGainMeters => real().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Activities, TrackPoints, Laps])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  /// In-memory database for tests. Never touches the filesystem.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
    beforeOpen: (details) async {
      // Off by default in SQLite, and required for the ON DELETE CASCADE
      // declared above to actually fire.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Declared here rather than in the table DSL, which has no index syntax.
  /// Both indexes serve the two queries this app actually runs: track points
  /// fetched per activity in time order, and the history list ordered by start
  /// time descending.
  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_track_points_activity '
      'ON track_points (activity_id, timestamp)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_laps_activity '
      'ON laps (activity_id, lap_index)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_activities_started_at '
      'ON activities (started_at DESC)',
    );
  }

  static QueryExecutor _open() {
    // Encryption note for the roadmap: switching this to an encrypted database
    // is a build-time change, not a schema change. Add
    //   hooks:
    //     user_defines:
    //       sqlite3:
    //         source: sqlite3mc
    // to pubspec.yaml and supply `PRAGMA key` in a setup callback here. The
    // tables, queries and repository above are unaffected.
    return driftDatabase(name: 'run_free');
  }
}
