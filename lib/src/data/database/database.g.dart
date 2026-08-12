// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, ActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _movingSecondsMeta = const VerificationMeta(
    'movingSeconds',
  );
  @override
  late final GeneratedColumn<int> movingSeconds = GeneratedColumn<int>(
    'moving_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _elevationGainMetersMeta =
      const VerificationMeta('elevationGainMeters');
  @override
  late final GeneratedColumn<double> elevationGainMeters =
      GeneratedColumn<double>(
        'elevation_gain_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _elevationLossMetersMeta =
      const VerificationMeta('elevationLossMeters');
  @override
  late final GeneratedColumn<double> elevationLossMeters =
      GeneratedColumn<double>(
        'elevation_loss_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _maxSpeedMetersPerSecondMeta =
      const VerificationMeta('maxSpeedMetersPerSecond');
  @override
  late final GeneratedColumn<double> maxSpeedMetersPerSecond =
      GeneratedColumn<double>(
        'max_speed_meters_per_second',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    startedAt,
    endedAt,
    title,
    notes,
    distanceMeters,
    movingSeconds,
    elapsedSeconds,
    elevationGainMeters,
    elevationLossMeters,
    maxSpeedMetersPerSecond,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('moving_seconds')) {
      context.handle(
        _movingSecondsMeta,
        movingSeconds.isAcceptableOrUnknown(
          data['moving_seconds']!,
          _movingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('elevation_gain_meters')) {
      context.handle(
        _elevationGainMetersMeta,
        elevationGainMeters.isAcceptableOrUnknown(
          data['elevation_gain_meters']!,
          _elevationGainMetersMeta,
        ),
      );
    }
    if (data.containsKey('elevation_loss_meters')) {
      context.handle(
        _elevationLossMetersMeta,
        elevationLossMeters.isAcceptableOrUnknown(
          data['elevation_loss_meters']!,
          _elevationLossMetersMeta,
        ),
      );
    }
    if (data.containsKey('max_speed_meters_per_second')) {
      context.handle(
        _maxSpeedMetersPerSecondMeta,
        maxSpeedMetersPerSecond.isAcceptableOrUnknown(
          data['max_speed_meters_per_second']!,
          _maxSpeedMetersPerSecondMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      movingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moving_seconds'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
      elevationGainMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elevation_gain_meters'],
      )!,
      elevationLossMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elevation_loss_meters'],
      )!,
      maxSpeedMetersPerSecond: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_meters_per_second'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class ActivityRow extends DataClass implements Insertable<ActivityRow> {
  /// UUID, so activities created on separate devices merge cleanly when sync
  /// arrives.
  final String id;

  /// [ActivityType.name]. Stored as text so enum reordering is harmless.
  final String type;

  /// UTC. Drift stores DateTime as a Unix timestamp in seconds by default.
  final DateTime startedAt;
  final DateTime endedAt;
  final String? title;
  final String? notes;
  final double distanceMeters;
  final int movingSeconds;
  final int elapsedSeconds;
  final double elevationGainMeters;
  final double elevationLossMeters;
  final double maxSpeedMetersPerSecond;
  const ActivityRow({
    required this.id,
    required this.type,
    required this.startedAt,
    required this.endedAt,
    this.title,
    this.notes,
    required this.distanceMeters,
    required this.movingSeconds,
    required this.elapsedSeconds,
    required this.elevationGainMeters,
    required this.elevationLossMeters,
    required this.maxSpeedMetersPerSecond,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['moving_seconds'] = Variable<int>(movingSeconds);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['elevation_gain_meters'] = Variable<double>(elevationGainMeters);
    map['elevation_loss_meters'] = Variable<double>(elevationLossMeters);
    map['max_speed_meters_per_second'] = Variable<double>(
      maxSpeedMetersPerSecond,
    );
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      type: Value(type),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      distanceMeters: Value(distanceMeters),
      movingSeconds: Value(movingSeconds),
      elapsedSeconds: Value(elapsedSeconds),
      elevationGainMeters: Value(elevationGainMeters),
      elevationLossMeters: Value(elevationLossMeters),
      maxSpeedMetersPerSecond: Value(maxSpeedMetersPerSecond),
    );
  }

  factory ActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRow(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      title: serializer.fromJson<String?>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      movingSeconds: serializer.fromJson<int>(json['movingSeconds']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      elevationGainMeters: serializer.fromJson<double>(
        json['elevationGainMeters'],
      ),
      elevationLossMeters: serializer.fromJson<double>(
        json['elevationLossMeters'],
      ),
      maxSpeedMetersPerSecond: serializer.fromJson<double>(
        json['maxSpeedMetersPerSecond'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'title': serializer.toJson<String?>(title),
      'notes': serializer.toJson<String?>(notes),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'movingSeconds': serializer.toJson<int>(movingSeconds),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'elevationGainMeters': serializer.toJson<double>(elevationGainMeters),
      'elevationLossMeters': serializer.toJson<double>(elevationLossMeters),
      'maxSpeedMetersPerSecond': serializer.toJson<double>(
        maxSpeedMetersPerSecond,
      ),
    };
  }

  ActivityRow copyWith({
    String? id,
    String? type,
    DateTime? startedAt,
    DateTime? endedAt,
    Value<String?> title = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    double? distanceMeters,
    int? movingSeconds,
    int? elapsedSeconds,
    double? elevationGainMeters,
    double? elevationLossMeters,
    double? maxSpeedMetersPerSecond,
  }) => ActivityRow(
    id: id ?? this.id,
    type: type ?? this.type,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    title: title.present ? title.value : this.title,
    notes: notes.present ? notes.value : this.notes,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    movingSeconds: movingSeconds ?? this.movingSeconds,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
    elevationLossMeters: elevationLossMeters ?? this.elevationLossMeters,
    maxSpeedMetersPerSecond:
        maxSpeedMetersPerSecond ?? this.maxSpeedMetersPerSecond,
  );
  ActivityRow copyWithCompanion(ActivitiesCompanion data) {
    return ActivityRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      movingSeconds: data.movingSeconds.present
          ? data.movingSeconds.value
          : this.movingSeconds,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      elevationGainMeters: data.elevationGainMeters.present
          ? data.elevationGainMeters.value
          : this.elevationGainMeters,
      elevationLossMeters: data.elevationLossMeters.present
          ? data.elevationLossMeters.value
          : this.elevationLossMeters,
      maxSpeedMetersPerSecond: data.maxSpeedMetersPerSecond.present
          ? data.maxSpeedMetersPerSecond.value
          : this.maxSpeedMetersPerSecond,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('movingSeconds: $movingSeconds, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('elevationGainMeters: $elevationGainMeters, ')
          ..write('elevationLossMeters: $elevationLossMeters, ')
          ..write('maxSpeedMetersPerSecond: $maxSpeedMetersPerSecond')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    startedAt,
    endedAt,
    title,
    notes,
    distanceMeters,
    movingSeconds,
    elapsedSeconds,
    elevationGainMeters,
    elevationLossMeters,
    maxSpeedMetersPerSecond,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.distanceMeters == this.distanceMeters &&
          other.movingSeconds == this.movingSeconds &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.elevationGainMeters == this.elevationGainMeters &&
          other.elevationLossMeters == this.elevationLossMeters &&
          other.maxSpeedMetersPerSecond == this.maxSpeedMetersPerSecond);
}

class ActivitiesCompanion extends UpdateCompanion<ActivityRow> {
  final Value<String> id;
  final Value<String> type;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<String?> title;
  final Value<String?> notes;
  final Value<double> distanceMeters;
  final Value<int> movingSeconds;
  final Value<int> elapsedSeconds;
  final Value<double> elevationGainMeters;
  final Value<double> elevationLossMeters;
  final Value<double> maxSpeedMetersPerSecond;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.movingSeconds = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.elevationGainMeters = const Value.absent(),
    this.elevationLossMeters = const Value.absent(),
    this.maxSpeedMetersPerSecond = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String id,
    required String type,
    required DateTime startedAt,
    required DateTime endedAt,
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.movingSeconds = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.elevationGainMeters = const Value.absent(),
    this.elevationLossMeters = const Value.absent(),
    this.maxSpeedMetersPerSecond = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt);
  static Insertable<ActivityRow> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<double>? distanceMeters,
    Expression<int>? movingSeconds,
    Expression<int>? elapsedSeconds,
    Expression<double>? elevationGainMeters,
    Expression<double>? elevationLossMeters,
    Expression<double>? maxSpeedMetersPerSecond,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (movingSeconds != null) 'moving_seconds': movingSeconds,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (elevationGainMeters != null)
        'elevation_gain_meters': elevationGainMeters,
      if (elevationLossMeters != null)
        'elevation_loss_meters': elevationLossMeters,
      if (maxSpeedMetersPerSecond != null)
        'max_speed_meters_per_second': maxSpeedMetersPerSecond,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<String?>? title,
    Value<String?>? notes,
    Value<double>? distanceMeters,
    Value<int>? movingSeconds,
    Value<int>? elapsedSeconds,
    Value<double>? elevationGainMeters,
    Value<double>? elevationLossMeters,
    Value<double>? maxSpeedMetersPerSecond,
    Value<int>? rowid,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      movingSeconds: movingSeconds ?? this.movingSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
      elevationLossMeters: elevationLossMeters ?? this.elevationLossMeters,
      maxSpeedMetersPerSecond:
          maxSpeedMetersPerSecond ?? this.maxSpeedMetersPerSecond,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (movingSeconds.present) {
      map['moving_seconds'] = Variable<int>(movingSeconds.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (elevationGainMeters.present) {
      map['elevation_gain_meters'] = Variable<double>(
        elevationGainMeters.value,
      );
    }
    if (elevationLossMeters.present) {
      map['elevation_loss_meters'] = Variable<double>(
        elevationLossMeters.value,
      );
    }
    if (maxSpeedMetersPerSecond.present) {
      map['max_speed_meters_per_second'] = Variable<double>(
        maxSpeedMetersPerSecond.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('movingSeconds: $movingSeconds, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('elevationGainMeters: $elevationGainMeters, ')
          ..write('elevationLossMeters: $elevationLossMeters, ')
          ..write('maxSpeedMetersPerSecond: $maxSpeedMetersPerSecond, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackPointsTable extends TrackPoints
    with TableInfo<$TrackPointsTable, TrackPointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headingMeta = const VerificationMeta(
    'heading',
  );
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
    'heading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    timestamp,
    latitude,
    longitude,
    altitude,
    speed,
    accuracy,
    heading,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackPointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    if (data.containsKey('heading')) {
      context.handle(
        _headingMeta,
        heading.isAcceptableOrUnknown(data['heading']!, _headingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackPointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackPointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      ),
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      ),
      heading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading'],
      ),
    );
  }

  @override
  $TrackPointsTable createAlias(String alias) {
    return $TrackPointsTable(attachedDatabase, alias);
  }
}

class TrackPointRow extends DataClass implements Insertable<TrackPointRow> {
  final int id;

  /// Deleting an activity must take its track with it, hence the cascade.
  final String activityId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? speed;
  final double? accuracy;
  final double? heading;
  const TrackPointRow({
    required this.id,
    required this.activityId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speed,
    this.accuracy,
    this.heading,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<String>(activityId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || speed != null) {
      map['speed'] = Variable<double>(speed);
    }
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<double>(heading);
    }
    return map;
  }

  TrackPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackPointsCompanion(
      id: Value(id),
      activityId: Value(activityId),
      timestamp: Value(timestamp),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      speed: speed == null && nullToAbsent
          ? const Value.absent()
          : Value(speed),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
    );
  }

  factory TrackPointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackPointRow(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<String>(json['activityId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      speed: serializer.fromJson<double?>(json['speed']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      heading: serializer.fromJson<double?>(json['heading']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<String>(activityId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'altitude': serializer.toJson<double?>(altitude),
      'speed': serializer.toJson<double?>(speed),
      'accuracy': serializer.toJson<double?>(accuracy),
      'heading': serializer.toJson<double?>(heading),
    };
  }

  TrackPointRow copyWith({
    int? id,
    String? activityId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    Value<double?> altitude = const Value.absent(),
    Value<double?> speed = const Value.absent(),
    Value<double?> accuracy = const Value.absent(),
    Value<double?> heading = const Value.absent(),
  }) => TrackPointRow(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    timestamp: timestamp ?? this.timestamp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    altitude: altitude.present ? altitude.value : this.altitude,
    speed: speed.present ? speed.value : this.speed,
    accuracy: accuracy.present ? accuracy.value : this.accuracy,
    heading: heading.present ? heading.value : this.heading,
  );
  TrackPointRow copyWithCompanion(TrackPointsCompanion data) {
    return TrackPointRow(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      speed: data.speed.present ? data.speed.value : this.speed,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      heading: data.heading.present ? data.heading.value : this.heading,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointRow(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('speed: $speed, ')
          ..write('accuracy: $accuracy, ')
          ..write('heading: $heading')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    timestamp,
    latitude,
    longitude,
    altitude,
    speed,
    accuracy,
    heading,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackPointRow &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitude == this.altitude &&
          other.speed == this.speed &&
          other.accuracy == this.accuracy &&
          other.heading == this.heading);
}

class TrackPointsCompanion extends UpdateCompanion<TrackPointRow> {
  final Value<int> id;
  final Value<String> activityId;
  final Value<DateTime> timestamp;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> altitude;
  final Value<double?> speed;
  final Value<double?> accuracy;
  final Value<double?> heading;
  const TrackPointsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
    this.speed = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.heading = const Value.absent(),
  });
  TrackPointsCompanion.insert({
    this.id = const Value.absent(),
    required String activityId,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    this.altitude = const Value.absent(),
    this.speed = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.heading = const Value.absent(),
  }) : activityId = Value(activityId),
       timestamp = Value(timestamp),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<TrackPointRow> custom({
    Expression<int>? id,
    Expression<String>? activityId,
    Expression<DateTime>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitude,
    Expression<double>? speed,
    Expression<double>? accuracy,
    Expression<double>? heading,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitude != null) 'altitude': altitude,
      if (speed != null) 'speed': speed,
      if (accuracy != null) 'accuracy': accuracy,
      if (heading != null) 'heading': heading,
    });
  }

  TrackPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? activityId,
    Value<DateTime>? timestamp,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double?>? altitude,
    Value<double?>? speed,
    Value<double?>? accuracy,
    Value<double?>? heading,
  }) {
    return TrackPointsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      accuracy: accuracy ?? this.accuracy,
      heading: heading ?? this.heading,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointsCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('speed: $speed, ')
          ..write('accuracy: $accuracy, ')
          ..write('heading: $heading')
          ..write(')'))
        .toString();
  }
}

class $LapsTable extends Laps with TableInfo<$LapsTable, LapRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LapsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lapIndexMeta = const VerificationMeta(
    'lapIndex',
  );
  @override
  late final GeneratedColumn<int> lapIndex = GeneratedColumn<int>(
    'lap_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elevationGainMetersMeta =
      const VerificationMeta('elevationGainMeters');
  @override
  late final GeneratedColumn<double> elevationGainMeters =
      GeneratedColumn<double>(
        'elevation_gain_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    lapIndex,
    distanceMeters,
    durationSeconds,
    elevationGainMeters,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'laps';
  @override
  VerificationContext validateIntegrity(
    Insertable<LapRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('lap_index')) {
      context.handle(
        _lapIndexMeta,
        lapIndex.isAcceptableOrUnknown(data['lap_index']!, _lapIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_lapIndexMeta);
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceMetersMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('elevation_gain_meters')) {
      context.handle(
        _elevationGainMetersMeta,
        elevationGainMeters.isAcceptableOrUnknown(
          data['elevation_gain_meters']!,
          _elevationGainMetersMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LapRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LapRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      lapIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lap_index'],
      )!,
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      elevationGainMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elevation_gain_meters'],
      )!,
    );
  }

  @override
  $LapsTable createAlias(String alias) {
    return $LapsTable(attachedDatabase, alias);
  }
}

class LapRow extends DataClass implements Insertable<LapRow> {
  final int id;
  final String activityId;
  final int lapIndex;
  final double distanceMeters;
  final int durationSeconds;
  final double elevationGainMeters;
  const LapRow({
    required this.id,
    required this.activityId,
    required this.lapIndex,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.elevationGainMeters,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<String>(activityId);
    map['lap_index'] = Variable<int>(lapIndex);
    map['distance_meters'] = Variable<double>(distanceMeters);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['elevation_gain_meters'] = Variable<double>(elevationGainMeters);
    return map;
  }

  LapsCompanion toCompanion(bool nullToAbsent) {
    return LapsCompanion(
      id: Value(id),
      activityId: Value(activityId),
      lapIndex: Value(lapIndex),
      distanceMeters: Value(distanceMeters),
      durationSeconds: Value(durationSeconds),
      elevationGainMeters: Value(elevationGainMeters),
    );
  }

  factory LapRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LapRow(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<String>(json['activityId']),
      lapIndex: serializer.fromJson<int>(json['lapIndex']),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      elevationGainMeters: serializer.fromJson<double>(
        json['elevationGainMeters'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<String>(activityId),
      'lapIndex': serializer.toJson<int>(lapIndex),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'elevationGainMeters': serializer.toJson<double>(elevationGainMeters),
    };
  }

  LapRow copyWith({
    int? id,
    String? activityId,
    int? lapIndex,
    double? distanceMeters,
    int? durationSeconds,
    double? elevationGainMeters,
  }) => LapRow(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    lapIndex: lapIndex ?? this.lapIndex,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
  );
  LapRow copyWithCompanion(LapsCompanion data) {
    return LapRow(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      lapIndex: data.lapIndex.present ? data.lapIndex.value : this.lapIndex,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      elevationGainMeters: data.elevationGainMeters.present
          ? data.elevationGainMeters.value
          : this.elevationGainMeters,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LapRow(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('lapIndex: $lapIndex, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('elevationGainMeters: $elevationGainMeters')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    lapIndex,
    distanceMeters,
    durationSeconds,
    elevationGainMeters,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LapRow &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.lapIndex == this.lapIndex &&
          other.distanceMeters == this.distanceMeters &&
          other.durationSeconds == this.durationSeconds &&
          other.elevationGainMeters == this.elevationGainMeters);
}

class LapsCompanion extends UpdateCompanion<LapRow> {
  final Value<int> id;
  final Value<String> activityId;
  final Value<int> lapIndex;
  final Value<double> distanceMeters;
  final Value<int> durationSeconds;
  final Value<double> elevationGainMeters;
  const LapsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.lapIndex = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.elevationGainMeters = const Value.absent(),
  });
  LapsCompanion.insert({
    this.id = const Value.absent(),
    required String activityId,
    required int lapIndex,
    required double distanceMeters,
    required int durationSeconds,
    this.elevationGainMeters = const Value.absent(),
  }) : activityId = Value(activityId),
       lapIndex = Value(lapIndex),
       distanceMeters = Value(distanceMeters),
       durationSeconds = Value(durationSeconds);
  static Insertable<LapRow> custom({
    Expression<int>? id,
    Expression<String>? activityId,
    Expression<int>? lapIndex,
    Expression<double>? distanceMeters,
    Expression<int>? durationSeconds,
    Expression<double>? elevationGainMeters,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (lapIndex != null) 'lap_index': lapIndex,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (elevationGainMeters != null)
        'elevation_gain_meters': elevationGainMeters,
    });
  }

  LapsCompanion copyWith({
    Value<int>? id,
    Value<String>? activityId,
    Value<int>? lapIndex,
    Value<double>? distanceMeters,
    Value<int>? durationSeconds,
    Value<double>? elevationGainMeters,
  }) {
    return LapsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      lapIndex: lapIndex ?? this.lapIndex,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (lapIndex.present) {
      map['lap_index'] = Variable<int>(lapIndex.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (elevationGainMeters.present) {
      map['elevation_gain_meters'] = Variable<double>(
        elevationGainMeters.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LapsCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('lapIndex: $lapIndex, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('elevationGainMeters: $elevationGainMeters')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $TrackPointsTable trackPoints = $TrackPointsTable(this);
  late final $LapsTable laps = $LapsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activities,
    trackPoints,
    laps,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('track_points', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('laps', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      required String id,
      required String type,
      required DateTime startedAt,
      required DateTime endedAt,
      Value<String?> title,
      Value<String?> notes,
      Value<double> distanceMeters,
      Value<int> movingSeconds,
      Value<int> elapsedSeconds,
      Value<double> elevationGainMeters,
      Value<double> elevationLossMeters,
      Value<double> maxSpeedMetersPerSecond,
      Value<int> rowid,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<String?> title,
      Value<String?> notes,
      Value<double> distanceMeters,
      Value<int> movingSeconds,
      Value<int> elapsedSeconds,
      Value<double> elevationGainMeters,
      Value<double> elevationLossMeters,
      Value<double> maxSpeedMetersPerSecond,
      Value<int> rowid,
    });

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, ActivityRow> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrackPointsTable, List<TrackPointRow>>
  _trackPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackPoints,
    aliasName: 'activities__id__track_points__activity_id',
  );

  $$TrackPointsTableProcessedTableManager get trackPointsRefs {
    final manager = $$TrackPointsTableTableManager(
      $_db,
      $_db.trackPoints,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LapsTable, List<LapRow>> _lapsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.laps,
    aliasName: 'activities__id__laps__activity_id',
  );

  $$LapsTableProcessedTableManager get lapsRefs {
    final manager = $$LapsTableTableManager(
      $_db,
      $_db.laps,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lapsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movingSeconds => $composableBuilder(
    column: $table.movingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevationLossMeters => $composableBuilder(
    column: $table.elevationLossMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedMetersPerSecond => $composableBuilder(
    column: $table.maxSpeedMetersPerSecond,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trackPointsRefs(
    Expression<bool> Function($$TrackPointsTableFilterComposer f) f,
  ) {
    final $$TrackPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableFilterComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lapsRefs(
    Expression<bool> Function($$LapsTableFilterComposer f) f,
  ) {
    final $$LapsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.laps,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LapsTableFilterComposer(
            $db: $db,
            $table: $db.laps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movingSeconds => $composableBuilder(
    column: $table.movingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevationLossMeters => $composableBuilder(
    column: $table.elevationLossMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedMetersPerSecond => $composableBuilder(
    column: $table.maxSpeedMetersPerSecond,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get movingSeconds => $composableBuilder(
    column: $table.movingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get elevationLossMeters => $composableBuilder(
    column: $table.elevationLossMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedMetersPerSecond => $composableBuilder(
    column: $table.maxSpeedMetersPerSecond,
    builder: (column) => column,
  );

  Expression<T> trackPointsRefs<T extends Object>(
    Expression<T> Function($$TrackPointsTableAnnotationComposer a) f,
  ) {
    final $$TrackPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lapsRefs<T extends Object>(
    Expression<T> Function($$LapsTableAnnotationComposer a) f,
  ) {
    final $$LapsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.laps,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LapsTableAnnotationComposer(
            $db: $db,
            $table: $db.laps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          ActivityRow,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (ActivityRow, $$ActivitiesTableReferences),
          ActivityRow,
          PrefetchHooks Function({bool trackPointsRefs, bool lapsRefs})
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<int> movingSeconds = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<double> elevationGainMeters = const Value.absent(),
                Value<double> elevationLossMeters = const Value.absent(),
                Value<double> maxSpeedMetersPerSecond = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                type: type,
                startedAt: startedAt,
                endedAt: endedAt,
                title: title,
                notes: notes,
                distanceMeters: distanceMeters,
                movingSeconds: movingSeconds,
                elapsedSeconds: elapsedSeconds,
                elevationGainMeters: elevationGainMeters,
                elevationLossMeters: elevationLossMeters,
                maxSpeedMetersPerSecond: maxSpeedMetersPerSecond,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required DateTime startedAt,
                required DateTime endedAt,
                Value<String?> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<int> movingSeconds = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<double> elevationGainMeters = const Value.absent(),
                Value<double> elevationLossMeters = const Value.absent(),
                Value<double> maxSpeedMetersPerSecond = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                type: type,
                startedAt: startedAt,
                endedAt: endedAt,
                title: title,
                notes: notes,
                distanceMeters: distanceMeters,
                movingSeconds: movingSeconds,
                elapsedSeconds: elapsedSeconds,
                elevationGainMeters: elevationGainMeters,
                elevationLossMeters: elevationLossMeters,
                maxSpeedMetersPerSecond: maxSpeedMetersPerSecond,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackPointsRefs = false, lapsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (trackPointsRefs) db.trackPoints,
                if (lapsRefs) db.laps,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trackPointsRefs)
                    await $_getPrefetchedData<
                      ActivityRow,
                      $ActivitiesTable,
                      TrackPointRow
                    >(
                      currentTable: table,
                      referencedTable: $$ActivitiesTableReferences
                          ._trackPointsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ActivitiesTableReferences(
                            db,
                            table,
                            p0,
                          ).trackPointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.activityId == item.id),
                      typedResults: items,
                    ),
                  if (lapsRefs)
                    await $_getPrefetchedData<
                      ActivityRow,
                      $ActivitiesTable,
                      LapRow
                    >(
                      currentTable: table,
                      referencedTable: $$ActivitiesTableReferences
                          ._lapsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ActivitiesTableReferences(db, table, p0).lapsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.activityId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      ActivityRow,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (ActivityRow, $$ActivitiesTableReferences),
      ActivityRow,
      PrefetchHooks Function({bool trackPointsRefs, bool lapsRefs})
    >;
typedef $$TrackPointsTableCreateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      required String activityId,
      required DateTime timestamp,
      required double latitude,
      required double longitude,
      Value<double?> altitude,
      Value<double?> speed,
      Value<double?> accuracy,
      Value<double?> heading,
    });
typedef $$TrackPointsTableUpdateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      Value<String> activityId,
      Value<DateTime> timestamp,
      Value<double> latitude,
      Value<double> longitude,
      Value<double?> altitude,
      Value<double?> speed,
      Value<double?> accuracy,
      Value<double?> heading,
    });

final class $$TrackPointsTableReferences
    extends BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPointRow> {
  $$TrackPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('track_points__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackPointsTable,
          TrackPointRow,
          $$TrackPointsTableFilterComposer,
          $$TrackPointsTableOrderingComposer,
          $$TrackPointsTableAnnotationComposer,
          $$TrackPointsTableCreateCompanionBuilder,
          $$TrackPointsTableUpdateCompanionBuilder,
          (TrackPointRow, $$TrackPointsTableReferences),
          TrackPointRow,
          PrefetchHooks Function({bool activityId})
        > {
  $$TrackPointsTableTableManager(_$AppDatabase db, $TrackPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> heading = const Value.absent(),
              }) => TrackPointsCompanion(
                id: id,
                activityId: activityId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
                speed: speed,
                accuracy: accuracy,
                heading: heading,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String activityId,
                required DateTime timestamp,
                required double latitude,
                required double longitude,
                Value<double?> altitude = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> heading = const Value.absent(),
              }) => TrackPointsCompanion.insert(
                id: id,
                activityId: activityId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
                speed: speed,
                accuracy: accuracy,
                heading: heading,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable: $$TrackPointsTableReferences
                                    ._activityIdTable(db),
                                referencedColumn: $$TrackPointsTableReferences
                                    ._activityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackPointsTable,
      TrackPointRow,
      $$TrackPointsTableFilterComposer,
      $$TrackPointsTableOrderingComposer,
      $$TrackPointsTableAnnotationComposer,
      $$TrackPointsTableCreateCompanionBuilder,
      $$TrackPointsTableUpdateCompanionBuilder,
      (TrackPointRow, $$TrackPointsTableReferences),
      TrackPointRow,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$LapsTableCreateCompanionBuilder =
    LapsCompanion Function({
      Value<int> id,
      required String activityId,
      required int lapIndex,
      required double distanceMeters,
      required int durationSeconds,
      Value<double> elevationGainMeters,
    });
typedef $$LapsTableUpdateCompanionBuilder =
    LapsCompanion Function({
      Value<int> id,
      Value<String> activityId,
      Value<int> lapIndex,
      Value<double> distanceMeters,
      Value<int> durationSeconds,
      Value<double> elevationGainMeters,
    });

final class $$LapsTableReferences
    extends BaseReferences<_$AppDatabase, $LapsTable, LapRow> {
  $$LapsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('laps__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LapsTableFilterComposer extends Composer<_$AppDatabase, $LapsTable> {
  $$LapsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapIndex => $composableBuilder(
    column: $table.lapIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LapsTableOrderingComposer extends Composer<_$AppDatabase, $LapsTable> {
  $$LapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapIndex => $composableBuilder(
    column: $table.lapIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LapsTable> {
  $$LapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lapIndex =>
      $composableBuilder(column: $table.lapIndex, builder: (column) => column);

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => column,
  );

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LapsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LapsTable,
          LapRow,
          $$LapsTableFilterComposer,
          $$LapsTableOrderingComposer,
          $$LapsTableAnnotationComposer,
          $$LapsTableCreateCompanionBuilder,
          $$LapsTableUpdateCompanionBuilder,
          (LapRow, $$LapsTableReferences),
          LapRow,
          PrefetchHooks Function({bool activityId})
        > {
  $$LapsTableTableManager(_$AppDatabase db, $LapsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LapsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LapsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LapsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<int> lapIndex = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> elevationGainMeters = const Value.absent(),
              }) => LapsCompanion(
                id: id,
                activityId: activityId,
                lapIndex: lapIndex,
                distanceMeters: distanceMeters,
                durationSeconds: durationSeconds,
                elevationGainMeters: elevationGainMeters,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String activityId,
                required int lapIndex,
                required double distanceMeters,
                required int durationSeconds,
                Value<double> elevationGainMeters = const Value.absent(),
              }) => LapsCompanion.insert(
                id: id,
                activityId: activityId,
                lapIndex: lapIndex,
                distanceMeters: distanceMeters,
                durationSeconds: durationSeconds,
                elevationGainMeters: elevationGainMeters,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LapsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable: $$LapsTableReferences
                                    ._activityIdTable(db),
                                referencedColumn: $$LapsTableReferences
                                    ._activityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LapsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LapsTable,
      LapRow,
      $$LapsTableFilterComposer,
      $$LapsTableOrderingComposer,
      $$LapsTableAnnotationComposer,
      $$LapsTableCreateCompanionBuilder,
      $$LapsTableUpdateCompanionBuilder,
      (LapRow, $$LapsTableReferences),
      LapRow,
      PrefetchHooks Function({bool activityId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$TrackPointsTableTableManager get trackPoints =>
      $$TrackPointsTableTableManager(_db, _db.trackPoints);
  $$LapsTableTableManager get laps => $$LapsTableTableManager(_db, _db.laps);
}
