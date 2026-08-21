// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_free/src/core/units.dart';
import 'package:run_free/src/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final units = ref.watch(unitSystemProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Units'),
          // RadioGroup owns the selection; the per-tile `groupValue`/`onChanged`
          // pair was deprecated after Flutter 3.32.
          RadioGroup<UnitSystem>(
            groupValue: units,
            onChanged: (value) {
              if (value != null) {
                ref.read(unitSystemProvider.notifier).set(value);
              }
            },
            child: Column(
              children: [
                for (final option in UnitSystem.values)
                  RadioListTile<UnitSystem>(
                    value: option,
                    title: Text(option.label),
                    subtitle: Text(
                      option == UnitSystem.metric
                          ? 'Kilometres, metres, min/km'
                          : 'Miles, feet, min/mi',
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 32),
          const _SectionHeader('Your data'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Everything stays on this device'),
            // Describes what is true now without promising it forever: opt-in
            // encrypted sync is on the roadmap, and this copy has to still be
            // honest the day it ships. "No analytics" is the unconditional
            // promise; "nothing is uploaded" is the current-state one.
            subtitle: const Text(
              'Run Free has no account and collects no analytics. Your '
              'activities are stored only on this phone, and map tiles are the '
              'sole network request the app makes.',
            ),
            isThreeLine: true,
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export your activities'),
            subtitle: const Text(
              'Open any activity and use the share button to export it as GPX.',
            ),
          ),

          const Divider(height: 32),
          const _SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.balance_outlined),
            title: const Text('Licence'),
            subtitle: const Text('Apache-2.0 — free and open source'),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Maps'),
            subtitle: const Text('© OpenStreetMap contributors'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Text(
              'Run Free',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
