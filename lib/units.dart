import 'dart:math';

import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';

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
    percentage,
    power,
    temperature,
    time,
    uValue,
    velocity,
    volume,
    wValue,
  ];

  static final time = UnitType(
    name: 'time',
    base: 's',
    fromBase: {
      'ms': (t) => t * 1000,
      's': (t) => t,
      'min': (t) => t / 60,
      'h': (t) => t / 3600,
      'd': (t) => t / 86400,
    },
  );

  static final length = UnitType(
    name: 'length',
    base: 'm',
    fromBase: {
      'mm': (l) => l * 1000,
      'cm': (l) => l * 100,
      'dm': (l) => l * 10,
      'm': (l) => l,
      'km': (l) => l / 1000,
    },
  );

  static final mass = UnitType(
    name: 'mass',
    base: 'kg',
    fromBase: {
      'mg': (m) => m * 1000000,
      'g': (m) => m * 1000,
      'kg': (m) => m,
      't': (m) => m / 1000,
    },
  );

  static final temperature = UnitType(
    name: 'temperature',
    base: 'K',
    fromBase: {
      'K': (t) => t,
      '°C': (t) => t - 273.15,
      '°F': (t) => (t - 273.15) * 9 / 5 + 32,
    },
    toBase: {
      'K': (t) => t,
      '°C': (t) => t + 273.15,
      '°F': (t) => (t - 32) * 5 / 9 + 273.15,
    },
  );

  static final velocity = UnitType(
    name: 'velocity',
    base: 'm/s',
    fromBase: {
      'm/s': (v) => v * length['m'] / time['s'],
      'km/h': (v) => v * length['km'] / time['h'],
    },
  );

  static final acceleration = UnitType(
    name: 'acceleration',
    base: 'm/s²',
    fromBase: {
      'm/s²': (a) => a * length['m'] / pow(time['s'], 2),
      'km/h²': (a) => a * length['km'] / pow(time['h'], 2),
    },
  );

  static final force = UnitType(
    name: 'force',
    base: 'N',
    fromBase: {
      'N': (f) => f * mass['kg'] * acceleration['m/s²'],
      'kN': (f) => f * mass['kg'] * acceleration['m/s²'] / 1000,
    },
  );

  static final energy = UnitType(
    name: 'energy',
    base: 'J',
    fromBase: {
      'J': (e) => e * force['N'] * length['m'],
      'kJ': (e) => e * force['N'] * length['m'] / 1000,
    },
  );

  static final power = UnitType(
    name: 'power',
    base: 'W',
    fromBase: {
      'W': (p) => p * energy['J'] / time['s'],
      'kW': (p) => p * energy['J'] / time['s'] / 1000,
    },
  );

  static final area = UnitType(
    name: 'area',
    base: 'm²',
    fromBase: {
      'cm²': (a) => a * pow(length['cm'], 2),
      'm²': (a) => a * pow(length['m'], 2),
    },
  );

  static final volume = UnitType(
    name: 'volume',
    base: 'm³',
    fromBase: {
      'cm³': (v) => v * pow(length['cm'], 3),
      'm³': (v) => v * pow(length['m'], 3),
      'l': (v) => v * pow(length['dm'], 3),
    },
  );

  static final arealDensity = UnitType(
    name: 'arealDensity',
    base: 'kg/m²',
    fromBase: {
      'g/cm²': (a) => a * mass['g'] / area['cm²'],
      'kg/m²': (a) => a * mass['kg'] / area['m²'],
      'mg/cm²': (a) => a * mass['mg'] / area['cm²'],
      'mg/m²': (a) => a * mass['mg'] / area['m²'],
    },
  );

  static final density = UnitType(
    name: 'density',
    base: 'kg/m³',
    fromBase: {
      'mg/cm³': (d) => d * mass['mg'] / volume['cm³'],
      'g/cm³': (d) => d * mass['g'] / volume['cm³'],
      'kg/m³': (d) => d * mass['kg'] / volume['m³'],
      'mg/l': (d) => d * mass['mg'] / volume['l'],
      'g/l': (d) => d * mass['g'] / volume['l'],
    },
  );

  static final wValue = UnitType(
    name: 'wValue',
    base: 'kg/m²√h',
    fromBase: {
      'kg/m²√s': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['s']) * 60),
      'kg/m²√h': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['h']) * 60),
      'kg/m²√d': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['d']) * 60),
    },
  );

  static final uValue = UnitType(
    name: 'uValue',
    base: 'W/m²K',
    fromBase: {'W/m²K': (u) => u * power['W'] / area['m²'] / temperature['K']},
  );

  static final percentage = UnitType(
    name: 'percentage',
    base: '%',
    fromBase: {'%': (p) => p, '‰': (p) => p / 10},
  );
}

typedef UnitConverter = Map<String, num Function(num)>;

class UnitType {
  UnitType({
    required this.name,
    required this.base,
    required this.fromBase,
    UnitConverter? toBase,
  }) : toBase = toBase ?? inverseOf(fromBase);

  static UnitConverter inverseOf(UnitConverter fromBase) {
    return fromBase.mapValues((converter) {
      return (value) => value / converter(1);
    });
  }

  final String name;
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

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return other is UnitType && name == other.name;
  }
}
