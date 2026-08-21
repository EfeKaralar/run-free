// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:run_free/src/core/formatters.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/domain/models/activity_stats.dart';
import 'package:run_free/src/features/shared/metric_tile.dart';
import 'package:run_free/src/features/shared/route_map.dart';
import 'package:run_free/src/providers.dart';

/// A saved activity: its route, summary numbers and splits.
class ActivityDetailScreen extends ConsumerWidget {
  const ActivityDetailScreen({required this.activityId, super.key});

  final String activityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityProvider(activityId));
    final formatters = Formatters(ref.watch(unitSystemProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text(activity.value?.displayTitle ?? 'Activity'),
        actions: [
          if (activity.value != null) ...[
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'Export GPX',
              onPressed: () => _export(context, ref, activity.value!),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: () => _delete(context, ref, activity.value!),
            ),
          ],
        ],
      ),
      body: activity.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load: $error')),
        data: (item) {
          // Null after a delete, while the route pops.
          if (item == null) {
            return const Center(child: Text('This activity was deleted.'));
          }
          return _Content(activity: item, formatters: formatters);
        },
      ),
    );
  }

  Future<void> _export(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(gpxServiceProvider).exportActivity(activity);
    } on Object catch (error) {
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('Export failed: $error')));
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) async {
    final router = GoRouter.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete activity?'),
        content: Text(
          '"${activity.displayTitle}" and its GPS track will be permanently '
          'deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!(confirmed ?? false)) return;

    await ref.read(activityRepositoryProvider).deleteActivity(activity.id);
    router.go('/');
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.activity, required this.formatters});

  final Activity activity;
  final Formatters formatters;

  @override
  Widget build(BuildContext context) {
    final stats = activity.stats;
    final preferPace = activity.type.prefersPaceOverSpeed;

    return ListView(
      children: [
        if (activity.hasTrack)
          SizedBox(height: 280, child: RouteMap(points: activity.points)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Formatters.activityDate(activity.startedAt),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              MetricRow(
                children: [
                  MetricTile(
                    label: 'Distance',
                    value: formatters.distance(stats.distanceMeters),
                  ),
                  MetricTile(
                    label: 'Moving time',
                    value: Formatters.duration(stats.movingDuration),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              MetricRow(
                children: [
                  MetricTile(
                    label: preferPace ? 'Avg pace' : 'Avg speed',
                    value: formatters.paceOrSpeed(
                      stats.averagePaceSecondsPerKm,
                      stats.averageSpeedMetersPerSecond,
                      preferPace: preferPace,
                    ),
                  ),
                  MetricTile(
                    label: 'Elev. gain',
                    value: formatters.elevation(stats.elevationGainMeters),
                  ),
                  MetricTile(
                    label: 'Elapsed',
                    value: Formatters.duration(stats.elapsedDuration),
                  ),
                ],
              ),
              if (activity.laps.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text('Splits', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _Splits(laps: activity.laps, formatters: formatters),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Splits extends StatelessWidget {
  const _Splits({required this.laps, required this.formatters});

  final List<ActivityLap> laps;
  final Formatters formatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Scale each bar against the slowest split so the differences are visible;
    // scaling from zero would compress every bar into near-identical widths.
    final paces = laps
        .map((l) => l.paceSecondsPerKm)
        .whereType<double>()
        .toList();
    final slowest = paces.isEmpty ? 1.0 : paces.reduce((a, b) => a > b ? a : b);
    final fastest = paces.isEmpty ? 0.0 : paces.reduce((a, b) => a < b ? a : b);
    final range = (slowest - fastest).abs() < 1 ? 1.0 : slowest - fastest;

    final splitUnit = formatters.units.distanceUnit;

    return Column(
      children: [
        for (final lap in laps)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    '${lap.index}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final pace = lap.paceSecondsPerKm;
                      // A short final split is faster per-km only by accident
                      // of where the user stopped, so it gets a muted bar.
                      final fraction = pace == null
                          ? 0.0
                          : (0.25 + 0.75 * ((slowest - pace) / range)).clamp(
                              0.05,
                              1.0,
                            );
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 20,
                          width: constraints.maxWidth * fraction,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.35,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 96,
                  child: Text(
                    formatters.pace(lap.paceSecondsPerKm),
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Per $splitUnit',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
