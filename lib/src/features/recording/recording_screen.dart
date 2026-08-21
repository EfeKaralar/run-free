// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:run_free/src/core/formatters.dart';
import 'package:run_free/src/domain/models/activity_type.dart';
import 'package:run_free/src/domain/services/location_tracker.dart';
import 'package:run_free/src/features/recording/recording_state.dart';
import 'package:run_free/src/features/shared/metric_tile.dart';
import 'package:run_free/src/features/shared/route_map.dart';
import 'package:run_free/src/providers.dart';

/// The live recording screen: map on top, metrics and controls below.
class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  @override
  void initState() {
    super.initState();
    // Deferred to after the first frame: reading a provider's notifier during
    // initState happens while the widget tree is still building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recordingControllerProvider.notifier).refreshPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingControllerProvider);
    final units = ref.watch(unitSystemProvider);
    final formatters = Formatters(units);
    final tileProvider = ref.watch(tileProviderProvider);

    // Surface errors as a snack bar rather than inline, so a transient failure
    // does not push the controls around mid-run.
    ref.listen(recordingControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && error != previous?.error) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(error)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: RouteMap(
                      points: state.points,
                      tileProvider: tileProvider,
                      followCurrentPosition: state.isActive,
                      showCurrentPositionMarker: state.isActive,
                    ),
                  ),
                  if (!state.isActive)
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: _ActivityTypeSelector(
                        selected: state.activityType,
                        enabled: !state.isBusy,
                        onChanged: (type) => ref
                            .read(recordingControllerProvider.notifier)
                            .selectActivityType(type),
                      ),
                    ),
                  if (state.isActive && !state.permission.isBackgroundCapable)
                    const Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: _BackgroundPermissionWarning(),
                    ),
                ],
              ),
            ),
            _MetricsPanel(state: state, formatters: formatters),
            _Controls(state: state),
          ],
        ),
      ),
    );
  }
}

class _MetricsPanel extends StatelessWidget {
  const _MetricsPanel({required this.state, required this.formatters});

  final RecordingState state;
  final Formatters formatters;

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final preferPace = state.activityType.prefersPaceOverSpeed;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          MetricTile(
            label: 'Distance',
            value: formatters.distance(stats.distanceMeters),
            emphasised: true,
          ),
          const SizedBox(height: 20),
          MetricRow(
            children: [
              MetricTile(
                label: 'Time',
                value: Formatters.duration(stats.elapsedDuration),
              ),
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
            ],
          ),
        ],
      ),
    );
  }
}

class _Controls extends ConsumerWidget {
  const _Controls({required this.state});

  final RecordingState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(recordingControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: switch (state.status) {
        RecordingStatus.idle => FilledButton.icon(
          onPressed: controller.start,
          icon: const Icon(Icons.play_arrow),
          label: Text('Start ${state.activityType.label.toLowerCase()}'),
        ),

        // A spinner rather than a disabled button: the user needs to know
        // something is happening, and the permission dialog may be up.
        RecordingStatus.preparing || RecordingStatus.saving => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          ),
        ),

        RecordingStatus.recording => Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: controller.pause,
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
              ),
            ),
          ],
        ),

        // Finish is only offered while paused. Requiring a deliberate pause
        // first makes it near-impossible to end a run by mis-tapping.
        RecordingStatus.paused => Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: controller.resume,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _finish(context, ref),
                icon: const Icon(Icons.stop),
                label: const Text('Finish'),
              ),
            ),
          ],
        ),
      },
    );
  }

  Future<void> _finish(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(recordingControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    if (!state.hasSaveableTrack) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Nothing recorded'),
          content: const Text(
            'This activity has no usable GPS track yet, so there is nothing '
            'to save. Discard it?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep recording'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      if (discard ?? false) await controller.discard();
      return;
    }

    final id = await controller.stop();
    if (id == null) return;

    messenger
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Activity saved')));
    router.go('/activity/$id');
  }
}

class _ActivityTypeSelector extends StatelessWidget {
  const _ActivityTypeSelector({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final ActivityType selected;
  final bool enabled;
  final ValueChanged<ActivityType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SegmentedButton<ActivityType>(
          segments: [
            for (final type in ActivityType.values)
              ButtonSegment(
                value: type,
                icon: Icon(type.icon),
                tooltip: type.label,
              ),
          ],
          selected: {selected},
          showSelectedIcon: false,
          onSelectionChanged: enabled
              ? (selection) => onChanged(selection.first)
              : null,
        ),
      ),
    );
  }
}

/// Shown when recording started with foreground-only permission.
///
/// This is the single most common way a tracking app silently loses a user's
/// run, so it is called out on the map rather than buried in settings.
class _BackgroundPermissionWarning extends ConsumerWidget {
  const _BackgroundPermissionWarning();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.errorContainer,
      child: ListTile(
        leading: Icon(Icons.warning_amber, color: scheme.onErrorContainer),
        title: Text(
          'Recording may stop when your screen turns off',
          style: TextStyle(color: scheme.onErrorContainer),
        ),
        subtitle: Text(
          'Allow location access "all the time" to record reliably.',
          style: TextStyle(color: scheme.onErrorContainer),
        ),
        trailing: TextButton(
          onPressed: () => ref
              .read(recordingControllerProvider.notifier)
              .requestPermission(),
          child: const Text('Fix'),
        ),
      ),
    );
  }
}
