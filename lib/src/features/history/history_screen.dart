// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:run_free/src/core/formatters.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/gpx/gpx_reader.dart';
import 'package:run_free/src/providers.dart';

/// The list of saved activities. The app's home screen.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activitiesProvider);
    final formatters = Formatters(ref.watch(unitSystemProvider));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'Import GPX',
            onPressed: () => _import(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: activities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(message: '$error'),
        data: (items) {
          if (items.isEmpty) return const _EmptyState();
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
            itemCount: items.length,
            itemBuilder: (context, index) => _ActivityCard(
              activity: items[index],
              formatters: formatters,
            ),
          );
        },
      ),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final units = ref.read(unitSystemProvider);

    try {
      final activity = await ref
          .read(gpxServiceProvider)
          .importActivity(splitDistanceMeters: units.splitDistanceMeters);

      // Null means the user backed out of the file picker; that is not an
      // outcome worth telling them about.
      if (activity == null) return;

      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text('Imported ${activity.displayTitle}')),
        );
    } on GpxParseException catch (error) {
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    } on Object catch (error) {
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('Import failed: $error')));
    }
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.formatters});

  final Activity activity;
  final Formatters formatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = activity.stats;
    final preferPace = activity.type.prefersPaceOverSpeed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/activity/${activity.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      activity.type.icon,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.displayTitle,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          Formatters.activityDate(activity.startedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Summary(
                    label: 'Distance',
                    value: formatters.distance(stats.distanceMeters),
                  ),
                  _Summary(
                    label: 'Time',
                    value: Formatters.duration(stats.movingDuration),
                  ),
                  _Summary(
                    label: preferPace ? 'Pace' : 'Speed',
                    value: formatters.paceOrSpeed(
                      stats.averagePaceSecondsPerKm,
                      stats.averageSpeedMetersPerSecond,
                      preferPace: preferPace,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_run,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No activities yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Head to the Record tab to start your first activity, or import '
              'an existing GPX file.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'Could not load your activities.\n\n$message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}