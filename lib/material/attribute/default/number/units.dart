import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';

const absoluteZero = -273.15;

abstract class UnitTypes {
  static final values = [
    acceleration,
    area,
    arealDensity,
    density,
    energy,
    force,
    length,
    mass,
    power,
    proportion,
    temperature,
    time,
    uValue,
    velocity,
    volume,
    wValue,
  ];

  static final time = UnitType(
    id: 'time',
    base: 's',
    fromBase: {
      'ms': (t) => t * Duration.millisecondsPerSecond,
      's': (t) => t,
      'min': (t) => t / Duration.secondsPerMinute,
      'h': (t) => t / Duration.secondsPerHour,
      'd': (t) => t / Duration.secondsPerDay,
    },
  );

  static final length = UnitType(
    id: 'length',
    base: 'm',
    fromBase: {
      'mm': (l) => l * 1000,
      'cm': (l) => l * 100,
      'm': (l) => l,
      'km': (l) => l / 1000,
      'µm': (l) => l * 1e6,
      'nm': (l) => l * 1e9,
    },
  );

  static final mass = UnitType(
    id: 'mass',
    base: 'kg',
    fromBase: {
      'mg': (m) => m * 1e6,
      'g': (m) => m * 1000,
      'kg': (m) => m,
      't': (m) => m / 1000,
    },
  );

  static final temperature = UnitType(
    id: 'temperature',
    base: 'K',
    fromBase: {
      'K': (t) => t,
      '°C': (t) => t + absoluteZero,
      '°F': (t) => (t + absoluteZero) * 9 / 5 + 32,
    },
    toBase: {
      'K': (t) => t,
      '°C': (t) => t - absoluteZero,
      '°F': (t) => (t - 32) * 5 / 9 - absoluteZero,
    },
  );

  static final velocity = UnitType(
    id: 'velocity',
    base: 'm/s',
    fromBase: {
      'm/s': (v) => v * length['m'] / time['s'],
      'mm/s': (v) => v * length['mm'] / time['s'],
      'km/h': (v) => v * length['km'] / time['h'],
    },
  );

  static final acceleration = UnitType(
    id: 'acceleration',
    base: 'm/s²',
    fromBase: {
      'm/s²': (a) => a * length['m'] / pow(time['s'], 2),
      'mm/s²': (a) => a * length['mm'] / pow(time['s'], 2),
    },
  );

  static final force = UnitType(
    id: 'force',
    base: 'N',
    fromBase: {
      'N': (f) => f * mass['kg'] * acceleration['m/s²'],
      'kN': (f) => f * mass['kg'] * acceleration['m/s²'] / 1000,
    },
  );

  static final energy = UnitType(
    id: 'energy',
    base: 'J',
    fromBase: {
      'J': (e) => e * force['N'] * length['m'],
      'kJ': (e) => e * force['N'] * length['m'] / 1000,
      'MJ': (e) => e * force['N'] * length['m'] / 1e6,
    },
  );

  static final power = UnitType(
    id: 'power',
    base: 'W',
    fromBase: {
      'W': (p) => p * energy['J'] / time['s'],
      'kW': (p) => p * energy['J'] / time['s'] / 1000,
      'MW': (p) => p * energy['J'] / time['s'] / 1e6,
    },
  );

  static final area = UnitType(
    id: 'area',
    base: 'm²',
    fromBase: {
      'mm²': (a) => a * pow(length['mm'], 2),
      'cm²': (a) => a * pow(length['cm'], 2),
      'm²': (a) => a * pow(length['m'], 2),
    },
  );

  static final volume = UnitType(
    id: 'volume',
    base: 'm³',
    fromBase: {
      'mm³': (v) => v * pow(length['mm'], 3),
      'cm³': (v) => v * pow(length['cm'], 3),
      'm³': (v) => v * pow(length['m'], 3),
      'l': (v) => v * pow(length['m'], 3) / 1000,
      'ml': (v) => v * pow(length['m'], 3) / 1e6,
    },
  );

  static final arealDensity = UnitType(
    id: 'arealDensity',
    base: 'kg/m²',
    fromBase: {
      'g/m²': (a) => a * mass['g'] / area['m²'],
      'kg/m²': (a) => a * mass['kg'] / area['m²'],
      'mg/cm²': (a) => a * mass['mg'] / area['cm²'],
    },
  );

  static final density = UnitType(
    id: 'density',
    base: 'kg/m³',
    fromBase: {
      'kg/m³': (d) => d * mass['kg'] / volume['m³'],
      'g/cm³': (d) => d * mass['g'] / volume['cm³'],
      'g/ml': (d) => d * mass['g'] / volume['ml'],
    },
  );

  static final wValue = UnitType(
    id: 'wValue',
    base: 'kg/m²√h',
    fromBase: {
      'kg/m²√s': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['s']) * 60),
      'kg/m²√h': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['h']) * 60),
      'kg/m²√d': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['d']) * 60),
    },
  );

  static final uValue = UnitType(
    id: 'uValue',
    base: 'W/m²K',
    fromBase: {
      'W/m²K': (u) => u * power['W'] / (area['m²'] * temperature['K']),
    },
  );

  static final proportion = UnitType(
    id: 'proportion',
    base: '%',
    fromBase: {'%': (p) => p, '‰': (p) => p * 10},
  );
}

typedef UnitConverter = Map<String, num Function(num)>;

class UnitType {
  UnitType({
    required this.id,
    required this.base,
    required this.fromBase,
    UnitConverter? toBase,
  }) : toBase = toBase ?? inverseOf(fromBase);

  static UnitConverter inverseOf(UnitConverter fromBase) {
    return fromBase.mapValues((converter) {
      return (value) => value / converter(1);
    });
  }

  final String id;
  final String base;
  final UnitConverter fromBase;
  final UnitConverter toBase;

  List<String> get units => fromBase.keys.toList();

  num operator [](String unit) {
    return fromBase[unit]!(1);
  }

  num convert(num value, {String? fromUnit, String? toUnit}) {
    if (fromUnit != null) {
      value = toBase[fromUnit]!(value);
    }
    if (toUnit != null) {
      value = fromBase[toUnit]!(value);
    }
    return value;
  }

  dynamic toJson() => id;

  static UnitType? maybeFromJson(dynamic id) {
    return UnitTypes.values.singleWhereOrNull((unit) => unit.id == id);
  }

  @override
  String toString() => id;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is UnitType && id == other.id;
  }
}
