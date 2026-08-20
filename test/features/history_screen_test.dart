// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/features/history/history_screen.dart';
import 'package:run_free/src/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widget-level tests for the history list.
///
/// These deliberately do **not** touch the database. `activitiesProvider` is
/// overridden with a ready [AsyncValue], for two reasons:
///
///  1. Storage behaviour is already covered by activity_repository_test.dart.
///     Driving a live drift stream from here would re-test it through a much
///     more fragile path.
///  2. A live stream leaves the screen on its loading branch for the first
///     frame or two. That branch renders an indeterminate
///     CircularProgressIndicator, which schedules frames forever — see the
///     warning on [pumpUntilFound] below.
void main() {
  late SharedPreferences preferences;

  Future<void> setPreferences([Map<String, Object> values = const {}]) async {
    SharedPreferences.setMockInitialValues(values);
    preferences = await SharedPreferences.getInstance();
  }

  setUp(() => setPreferences());

  Activity buildActivity({
    String id = 'a1',
    ActivityType type = ActivityType.run,
    String? title,
    double distanceMeters = 5023,
    Duration movingDuration = const Duration(minutes: 25, seconds: 5),
    DateTime? startedAt,
  }) {
    final start = startedAt ?? DateTime.utc(2026, 8, 12, 7);
    return Activity(
      id: id,
      type: type,
      startedAt: start,
      endedAt: start.add(const Duration(minutes: 30)),
      title: title,
      stats: ActivityStats(
        distanceMeters: distanceMeters,
        movingDuration: movingDuration,
        elapsedDuration: const Duration(minutes: 30),
      ),
    );
  }

  Widget buildSubject(List<Activity> activities) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        activitiesProvider.overrideWithValue(AsyncValue.data(activities)),
      ],
      child: const MaterialApp(home: HistoryScreen()),
    );
  }

  /// Pumps a bounded number of frames until [finder] matches.
  ///
  /// **Never use `pumpAndSettle()` on this screen.** Its loading branch renders
  /// an indeterminate CircularProgressIndicator, which schedules a new frame on
  /// every tick indefinitely. `pumpAndSettle` waits for no frame to be
  /// scheduled, so it cannot settle while that spinner is visible and instead
  /// spins for its full ten-minute default timeout — the test appears hung
  /// rather than failing. This helper fails in milliseconds instead.
  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    int maxFrames = 20,
  }) async {
    for (var i = 0; i < maxFrames; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for $finder');
  }

  testWidgets('shows the empty state when nothing is recorded', (tester) async {
    await tester.pumpWidget(buildSubject(const []));
    await pumpUntilFound(tester, find.text('No activities yet'));

    expect(find.text('No activities yet'), findsOneWidget);
  });

  testWidgets('lists a saved activity with its summary numbers', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject([buildActivity(title: 'Riverside loop')]),
    );
    await pumpUntilFound(tester, find.text('Riverside loop'));

    expect(find.text('Riverside loop'), findsOneWidget);
    expect(find.text('5.02 km'), findsOneWidget);
    expect(find.text('25:05'), findsOneWidget);
    expect(find.text('No activities yet'), findsNothing);
  });

  testWidgets('renders distances in the selected unit system', (tester) async {
    await setPreferences({'unit_system': 'imperial'});

    await tester.pumpWidget(
      buildSubject([buildActivity(distanceMeters: 5000)]),
    );
    await pumpUntilFound(tester, find.text('3.11 mi'));

    expect(find.text('3.11 mi'), findsOneWidget);
  });

  testWidgets('falls back to a time-of-day title when none is set', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject([
        // Asserting on the sport alone keeps this independent of the machine's
        // timezone, which decides the "Morning"/"Evening" half of the name.
        buildActivity(type: ActivityType.ride, title: null),
      ]),
    );
    await pumpUntilFound(tester, find.textContaining('Ride'));

    expect(find.textContaining('Ride'), findsOneWidget);
  });

  testWidgets('shows a row per activity', (tester) async {
    await tester.pumpWidget(
      buildSubject([
        buildActivity(id: 'a1', title: 'First'),
        buildActivity(id: 'a2', title: 'Second'),
        buildActivity(id: 'a3', title: 'Third'),
      ]),
    );
    await pumpUntilFound(tester, find.text('First'));

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(find.text('Third'), findsOneWidget);
  });
}