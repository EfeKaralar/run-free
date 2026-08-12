// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_free/src/core/units.dart';
import 'package:run_free/src/data/database/database.dart';
import 'package:run_free/src/data/repositories/activity_repository.dart';
import 'package:run_free/src/data/repositories/drift_activity_repository.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/services/location_tracker.dart';
import 'package:run_free/src/domain/services/tracelet_location_tracker.dart';
import 'package:run_free/src/features/recording/recording_controller.dart';
import 'package:run_free/src/features/recording/recording_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Providers are written by hand rather than generated. Riverpod's codegen is
/// excellent, but drift already puts build_runner in the loop, and keeping the
/// provider graph readable without a generation step lowers the barrier for
/// contributors.

/// The Drift database. One instance for the process lifetime.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Overridden in tests with a fake, and later the place where an encrypting or
/// syncing decorator would be wrapped around the Drift implementation.
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return DriftActivityRepository(ref.watch(databaseProvider));
});

/// The platform geolocation engine.
final locationTrackerProvider = Provider<LocationTracker>((ref) {
  final tracker = TraceletLocationTracker();
  ref.onDispose(tracker.dispose);
  return tracker;
});

/// Loaded once at startup in `main`, so the rest of the app can read settings
/// synchronously instead of threading a Future through every widget.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

const _unitSystemKey = 'unit_system';

/// The user's metric/imperial preference, persisted across launches.
class UnitSystemController extends Notifier<UnitSystem> {
  @override
  UnitSystem build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return UnitSystem.fromName(prefs.getString(_unitSystemKey));
  }

  Future<void> set(UnitSystem units) async {
    state = units;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_unitSystemKey, units.name);
  }
}

final unitSystemProvider = NotifierProvider<UnitSystemController, UnitSystem>(
  UnitSystemController.new,
);

/// The live recording session.
///
/// Deliberately not auto-disposed: a session must survive the user navigating
/// away from the recording screen to check their history mid-run.
final recordingControllerProvider =
    NotifierProvider<RecordingController, RecordingState>(
      RecordingController.new,
    );

/// All saved activities, newest first, without their tracks.
final activitiesProvider = StreamProvider<List<Activity>>((ref) {
  return ref.watch(activityRepositoryProvider).watchActivities();
});

/// One activity with its full track. Auto-disposed: tracks are large and there
/// is no reason to keep one resident after its screen closes.
final activityProvider = StreamProvider.autoDispose
    .family<Activity?, String>((ref, id) {
      return ref.watch(activityRepositoryProvider).watchActivity(id);
    });