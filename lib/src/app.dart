// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:run_free/src/core/theme.dart';
import 'package:run_free/src/router.dart';

class RunFreeApp extends StatefulWidget {
  const RunFreeApp({super.key});

  @override
  State<RunFreeApp> createState() => _RunFreeAppState();
}

class _RunFreeAppState extends State<RunFreeApp> {
  // Built once and held: rebuilding the router would reset navigation state on
  // every theme or settings change.
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Run Free',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Follow the system setting. An explicit in-app override can come later
      // if users ask for it.
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}