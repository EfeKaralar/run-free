// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

/// The user's preferred measurement system.
///
/// Everything is stored in metric (metres, seconds) and converted only at the
/// display layer. Storing display units would make the database ambiguous the
/// moment the user changes this setting.
enum UnitSystem {
  metric(label: 'Metric', distanceUnit: 'km', shortDistanceUnit: 'm'),
  imperial(label: 'Imperial', distanceUnit: 'mi', shortDistanceUnit: 'ft');

  const UnitSystem({
    required this.label,
    required this.distanceUnit,
    required this.shortDistanceUnit,
  });

  final String label;

  /// Unit for long distances, used in the split label and totals.
  final String distanceUnit;

  /// Unit for short distances, used for elevation.
  final String shortDistanceUnit;

  static const double _metersPerMile = 1609.344;
  static const double _feetPerMeter = 3.280839895;

  /// The distance one split covers, in metres.
  double get splitDistanceMeters =>
      this == UnitSystem.metric ? 1000.0 : _metersPerMile;

  double distanceFromMeters(double meters) =>
      this == UnitSystem.metric ? meters / 1000.0 : meters / _metersPerMile;

  double elevationFromMeters(double meters) =>
      this == UnitSystem.metric ? meters : meters * _feetPerMeter;

  /// Converts a pace expressed per kilometre into pace per display unit.
  double paceFromSecondsPerKm(double secondsPerKm) => this == UnitSystem.metric
      ? secondsPerKm
      : secondsPerKm * (_metersPerMile / 1000.0);

  /// Converts m/s into km/h or mph.
  double speedFromMetersPerSecond(double metersPerSecond) =>
      this == UnitSystem.metric
      ? metersPerSecond * 3.6
      : metersPerSecond * 3600 / _metersPerMile;

  String get speedUnit => this == UnitSystem.metric ? 'km/h' : 'mph';
  String get paceUnit => this == UnitSystem.metric ? '/km' : '/mi';

  static UnitSystem fromName(String? name) => UnitSystem.values.firstWhere(
    (u) => u.name == name,
    orElse: () => UnitSystem.metric,
  );
}
