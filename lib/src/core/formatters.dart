// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:intl/intl.dart';
import 'package:run_free/src/core/units.dart';

/// Display formatting for every number the app shows.
///
/// Centralised so that "5.02 km" and "26:04 /mi" are formatted identically
/// wherever they appear, and so unit conversion happens in exactly one place.
class Formatters {
  const Formatters(this.units);

  final UnitSystem units;

  /// `1:23:45` for durations of an hour or more, `23:45` otherwise.
  ///
  /// Elapsed time on a run is read at a glance while moving, so the leading
  /// `0:` on a sub-hour activity is noise worth dropping.
  static String duration(Duration d) {
    final totalSeconds = d.inSeconds.abs();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final two = NumberFormat('00');
    if (hours > 0) {
      return '$hours:${two.format(minutes)}:${two.format(seconds)}';
    }
    return '$minutes:${two.format(seconds)}';
  }

  /// Distance with the precision that actually matters at that magnitude.
  ///
  /// Below 1 km the raw metre count is more useful than "0.42 km".
  String distance(double meters, {bool withUnit = true}) {
    final converted = units.distanceFromMeters(meters);
    if (converted < 1) {
      final short = units == UnitSystem.metric
          ? meters
          : units.elevationFromMeters(meters);
      final value = short.round();
      return withUnit ? '$value ${units.shortDistanceUnit}' : '$value';
    }
    final text = converted.toStringAsFixed(2);
    return withUnit ? '$text ${units.distanceUnit}' : text;
  }

  /// Pace as `m:ss`, the form every runner reads.
  ///
  /// Returns an em dash rather than `0:00` when pace is undefined — a stopped
  /// runner has no pace, and showing zero implies infinite speed.
  String pace(double? secondsPerKm, {bool withUnit = true}) {
    if (secondsPerKm == null || secondsPerKm <= 0 || !secondsPerKm.isFinite) {
      return withUnit ? '—' : '—';
    }
    final converted = units.paceFromSecondsPerKm(secondsPerKm);

    // Beyond ~1h/km the reading is meaningless (the user has stopped) and the
    // m:ss form breaks down.
    if (converted > 3600) return '—';

    final minutes = converted ~/ 60;
    final seconds = (converted % 60).round();
    // Rounding 59.6s up must roll over into the next minute, not print ":60".
    final adjustedMinutes = seconds == 60 ? minutes + 1 : minutes;
    final adjustedSeconds = seconds == 60 ? 0 : seconds;

    final text =
        '$adjustedMinutes:${NumberFormat('00').format(adjustedSeconds)}';
    return withUnit ? '$text ${units.paceUnit}' : text;
  }

  String speed(double metersPerSecond, {bool withUnit = true}) {
    final converted = units.speedFromMetersPerSecond(metersPerSecond);
    final text = converted.toStringAsFixed(1);
    return withUnit ? '$text ${units.speedUnit}' : text;
  }

  String elevation(double meters, {bool withUnit = true}) {
    final value = units.elevationFromMeters(meters).round();
    return withUnit ? '$value ${units.shortDistanceUnit}' : '$value';
  }

  /// Either pace or speed, depending on what the sport is normally measured in.
  String paceOrSpeed(double? secondsPerKm, double metersPerSecond,
      {required bool preferPace}) {
    return preferPace ? pace(secondsPerKm) : speed(metersPerSecond);
  }

  /// `Today at 07:14`, `Yesterday at 18:02`, or `12 Aug 2026 at 07:14`.
  static String activityDate(DateTime utc) {
    final local = utc.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(local.year, local.month, local.day);
    final time = DateFormat.Hm().format(local);

    final difference = today.difference(that).inDays;
    return switch (difference) {
      0 => 'Today at $time',
      1 => 'Yesterday at $time',
      _ => '${DateFormat.yMMMd().format(local)} at $time',
    };
  }

  /// Filesystem-safe timestamp for exported files: `2026-08-12_071432`.
  static String fileTimestamp(DateTime utc) =>
      DateFormat('yyyy-MM-dd_HHmmss').format(utc.toLocal());
}