// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_free/src/data/database/database.dart';
import 'package:run_free/src/data/repositories/drift_activity_repository.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/activity_type.dart';

import '../domain/stats_calculator_test.dart' show straightTrack;

/// Exercises the real Drift schema against an in-memory SQLite database, so
/// migrations, cascades and the row/domain mapping are all covered without
/// touching a device.
void main() {
  late AppDatabase db;
  late DriftActivityRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftActivityRepository(db);
  });

  tearDown(() => db.close());

  Activity buildActivity({
    String id = 'a1',
    ActivityType type = ActivityType.run,
    DateTime? startedAt,
    int pointCount = 11,
    String? title,
  }) {
    final track = straightTrack(count: pointCount);
    final start = startedAt ?? track.first.timestamp;
    return Activity(
      id: id,
      type: type,
      startedAt: start,
      endedAt: track.last.timestamp,
      title: title,
      stats: const ActivityStats(
        distanceMeters: 5000,
        movingDuration: Duration(minutes: 25),
        elapsedDuration: Duration(minutes: 27),
        elevationGainMeters: 42,
      ),
      points: track,
      laps: const [
        ActivityLap(
          index: 1,
          distanceMeters: 1000,
          duration: Duration(minutes: 5),
          elevationGainMeters: 10,
        ),
        ActivityLap(
          index: 2,
          distanceMeters: 1000,
          duration: Duration(minutes: 5, seconds: 12),
          elevationGainMeters: 8,
        ),
      ],
    );
  }

  test('saves and reads back an activity with its track and laps', () async {
    await repository.saveActivity(buildActivity());

    final loaded = await repository.getActivity('a1');

    expect(loaded, isNotNull);
    expect(loaded!.type, ActivityType.run);
    expect(loaded.stats.distanceMeters, 5000);
    expect(loaded.stats.movingDuration, const Duration(minutes: 25));
    expect(loaded.stats.elevationGainMeters, 42);
    expect(loaded.points.length, 11);
    expect(loaded.laps.length, 2);
  });

  test('preserves track point ordering and optional fields', () async {
    await repository.saveActivity(buildActivity());
    final loaded = await repository.getActivity('a1');

    final timestamps = loaded!.points.map((p) => p.timestamp).toList();
    expect(
      timestamps,
      orderedEquals(List<DateTime>.from(timestamps)..sort()),
      reason: 'points must come back in chronological order',
    );
    expect(loaded.points.first.accuracy, 5);
  });

  test('returns null for an unknown id', () async {
    expect(await repository.getActivity('nope'), isNull);
  });

  test('the history list is newest first', () async {
    await repository.saveActivity(
      buildActivity(id: 'old', startedAt: DateTime.utc(2026, 1, 1)),
    );
    await repository.saveActivity(
      buildActivity(id: 'new', startedAt: DateTime.utc(2026, 6, 1)),
    );

    final activities = await repository.watchActivities().first;
    expect(activities.map((a) => a.id), ['new', 'old']);
  });

  test('the history list omits track points', () async {
    await repository.saveActivity(buildActivity());

    final activities = await repository.watchActivities().first;
    expect(
      activities.single.points,
      isEmpty,
      reason: 'loading tracks for the list would be needlessly expensive',
    );
    // Summary numbers still come through, because they live on the row.
    expect(activities.single.stats.distanceMeters, 5000);
  });

  test('deleting an activity removes its track and laps too', () async {
    await repository.saveActivity(buildActivity());
    await repository.deleteActivity('a1');

    expect(await repository.getActivity('a1'), isNull);
    // The cascade only fires because `PRAGMA foreign_keys = ON` runs on open;
    // this assertion is what catches that pragma going missing.
    expect(await db.select(db.trackPoints).get(), isEmpty);
    expect(await db.select(db.laps).get(), isEmpty);
  });

  test('updating details leaves the recorded track untouched', () async {
    await repository.saveActivity(buildActivity());

    await repository.updateActivityDetails(
      id: 'a1',
      title: 'Riverside loop',
      notes: 'Windy.',
    );

    final loaded = await repository.getActivity('a1');
    expect(loaded!.title, 'Riverside loop');
    expect(loaded.notes, 'Windy.');
    expect(loaded.points.length, 11);
    expect(loaded.stats.distanceMeters, 5000);
  });

  test('counts saved activities', () async {
    expect(await repository.countActivities(), 0);
    await repository.saveActivity(buildActivity(id: 'a1'));
    await repository.saveActivity(buildActivity(id: 'a2'));
    expect(await repository.countActivities(), 2);
  });

  test('watchActivities emits again when an activity is added', () async {
    // Held unawaited: awaiting here would block before the save that produces
    // the emission. `emitsThrough` rather than `emitsInOrder` because drift
    // resolves its first query asynchronously, so whether the initial empty
    // list arrives before or after the save is a race we do not care about.
    final expectation = expectLater(
      repository.watchActivities(),
      emitsThrough(hasLength(1)),
    );

    await repository.saveActivity(buildActivity());

    await expectation;
  });

  test('an activity with no title falls back to a time-of-day name', () async {
    // 08:00 UTC. Converted to local time by displayTitle, so assert loosely.
    await repository.saveActivity(buildActivity(title: null));
    final loaded = await repository.getActivity('a1');
    expect(loaded!.displayTitle, contains('Run'));
  });
}
