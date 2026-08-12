// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:run_free/src/domain/models/activity.dart';

/// The single door between the app and stored activity data.
///
/// Nothing above this interface knows that Drift, or SQLite, or a file on disk
/// is involved. That is the whole point: the roadmap calls for encrypting
/// activity data at rest and letting users sync it to a server of their choice,
/// and both land as new implementations of this interface (or a decorator
/// around [DriftActivityRepository]) rather than as edits scattered through the
/// UI.
///
/// Methods returning a [Stream] emit again whenever the underlying data
/// changes, so screens stay live without manual refresh calls.
abstract interface class ActivityRepository {
  /// All saved activities, newest first, **without** their track points.
  ///
  /// Points are excluded on purpose — the history list would otherwise pull
  /// millions of rows to render a handful of summary cards.
  Stream<List<Activity>> watchActivities();

  /// A single activity including its full track and splits, or `null` if it
  /// has been deleted.
  Stream<Activity?> watchActivity(String id);

  /// Loads one activity with its track, without subscribing to updates.
  Future<Activity?> getActivity(String id);

  /// Inserts a new activity together with its points and laps, in one
  /// transaction. A half-written activity is worse than no activity.
  Future<void> saveActivity(Activity activity);

  /// Updates only the user-editable fields. Never touches the recorded track.
  Future<void> updateActivityDetails({
    required String id,
    String? title,
    String? notes,
  });

  Future<void> deleteActivity(String id);

  /// Total number of saved activities, for the empty-state and settings screens.
  Future<int> countActivities();
}