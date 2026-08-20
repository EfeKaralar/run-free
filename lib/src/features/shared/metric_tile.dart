// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:run_free/src/core/theme.dart';

/// One labelled number, as shown on the recording and detail screens.
class MetricTile extends StatelessWidget {
  const MetricTile({
    required this.label,
    required this.value,
    this.emphasised = false,
    super.key,
  });

  final String label;
  final String value;

  /// Renders larger. Reserved for the single number that matters most on the
  /// screen — glanceability while moving depends on there being exactly one.
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final valueStyle = emphasised
        ? AppTheme.metricValue(context).copyWith(fontSize: 56, height: 1.1)
        : AppTheme.metricValue(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: valueStyle,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: AppTheme.metricLabel(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// A row of metrics that divides the available width evenly.
class MetricRow extends StatelessWidget {
  const MetricRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final child in children) Expanded(child: child),
      ],
    );
  }
}