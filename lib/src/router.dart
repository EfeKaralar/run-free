// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_free/src/features/activity_detail/activity_detail_screen.dart';
import 'package:run_free/src/features/history/history_screen.dart';
import 'package:run_free/src/features/recording/recording_screen.dart';
import 'package:run_free/src/features/settings/settings_screen.dart';

/// Navigation for the whole app.
///
/// A [StatefulShellRoute] rather than a plain bottom bar over an IndexedStack:
/// it keeps a separate Navigator per tab, so the map on the recording tab is
/// not torn down and rebuilt every time the user glances at their history
/// mid-run.
GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HistoryScreen(),
                routes: [
                  GoRoute(
                    path: 'activity/:id',
                    builder: (context, state) => ActivityDetailScreen(
                      activityId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/record',
                builder: (context, state) => const RecordingScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the active tab returns it to its root, which is the
          // convention users expect from every other tabbed app.
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.radio_button_checked_outlined),
            selectedIcon: Icon(Icons.radio_button_checked),
            label: 'Record',
          ),
        ],
      ),
    );
  }
}