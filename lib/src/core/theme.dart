// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

/// Run Free's Material 3 theme.
///
/// Both brightnesses are built from one seed so the palettes stay related. A
/// dark theme is not optional for this app: early-morning and evening runs are
/// exactly when people look at their phone, and a white screen at 6am is
/// hostile.
abstract final class AppTheme {
  /// Warm orange — visible in direct sunlight, distinct from the blue every
  /// mapping app uses for the route line.
  static const seed = Color(0xFFE85D24);

  /// The recorded route, drawn over the map.
  static const trackColor = Color(0xFFE85D24);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  /// Text style for the big live numbers on the recording screen.
  ///
  /// Tabular figures matter here: without them the digits shift horizontally
  /// every time the seconds tick over, which is maddening to read while moving.
  static TextStyle metricValue(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
      fontWeight: FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle metricLabel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      color: scheme.onSurfaceVariant,
      letterSpacing: 0.8,
    );
  }
}
