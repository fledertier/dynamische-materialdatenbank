import 'dart:math';

import 'package:dynamische_materialdatenbank/utils.dart';

final time = Unit(
  name: 'Time',
  base: 's',
  fromBase: {
    'ms': (t) => t * 1000,
    's': (t) => t,
    'min': (t) => t / 60,
    'h': (t) => t / 3600,
    'd': (t) => t / 86400,
  },
);

final length = Unit(
  name: 'Length',
  base: 'm',
  fromBase: {
    'mm': (l) => l * 1000,
    'cm': (l) => l * 100,
    'dm': (l) => l * 10,
    'm': (l) => l,
    'km': (l) => l / 1000,
  },
);

final mass = Unit(
  name: 'Mass',
  base: 'kg',
  fromBase: {
    'mg': (m) => m * 1000000,
    'g': (m) => m * 1000,
    'kg': (m) => m,
    't': (m) => m / 1000,
  },
);

final temperature = Unit(
  name: 'Temperature',
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

final velocity = Unit(
  name: 'Velocity',
  base: 'm/s',
  fromBase: {
    'm/s': (v) => v * length['m'] / time['s'],
    'km/h': (v) => v * length['km'] / time['h'],
  },
);

final acceleration = Unit(
  name: 'Acceleration',
  base: 'm/s²',
  fromBase: {
    'm/s²': (a) => a * length['m'] / pow(time['s'], 2),
    'km/h²': (a) => a * length['km'] / pow(time['h'], 2),
  },
);

final force = Unit(
  name: 'Force',
  base: 'N',
  fromBase: {
    'N': (f) => f * mass['kg'] * acceleration['m/s²'],
    'kN': (f) => f * mass['kg'] * acceleration['m/s²'] / 1000,
  },
);

final energy = Unit(
  name: 'Energy',
  base: 'J',
  fromBase: {
    'J': (e) => e * force['N'] * length['m'],
    'kJ': (e) => e * force['N'] * length['m'] / 1000,
  },
);

final power = Unit(
  name: 'Power',
  base: 'W',
  fromBase: {
    'W': (p) => p * energy['J'] / time['s'],
    'kW': (p) => p * energy['J'] / time['s'] / 1000,
  },
);

final area = Unit(
  name: 'Area',
  base: 'm²',
  fromBase: {
    'cm²': (a) => a * pow(length['cm'], 2),
    'm²': (a) => a * pow(length['m'], 2),
  },
);

final volume = Unit(
  name: 'Volume',
  base: 'm³',
  fromBase: {
    'cm³': (v) => v * pow(length['cm'], 3),
    'm³': (v) => v * pow(length['m'], 3),
    'l': (v) => v * pow(length['dm'], 3),
  },
);

final arealDensity = Unit(
  name: 'Areal density',
  base: 'kg/m²',
  fromBase: {
    'g/cm²': (a) => a * mass['g'] / area['cm²'],
    'kg/m²': (a) => a * mass['kg'] / area['m²'],
    'mg/cm²': (a) => a * mass['mg'] / area['cm²'],
    'mg/m²': (a) => a * mass['mg'] / area['m²'],
  },
);

final density = Unit(
  name: 'Density',
  base: 'kg/m³',
  fromBase: {
    'mg/cm³': (d) => d * mass['mg'] / volume['cm³'],
    'g/cm³': (d) => d * mass['g'] / volume['cm³'],
    'kg/m³': (d) => d * mass['kg'] / volume['m³'],
    'mg/l': (d) => d * mass['mg'] / volume['l'],
    'g/l': (d) => d * mass['g'] / volume['l'],
  },
);

final wValue = Unit(
  name: 'W-value',
  base: 'kg/m²√h',
  fromBase: {
    'kg/m²√s': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['s']) * 60),
    'kg/m²√h': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['h']) * 60),
    'kg/m²√d': (w) => w * mass['kg'] / (area['m²'] * sqrt(time['d']) * 60),
  },
);

final uValue = Unit(
  name: 'U-value',
  base: 'W/m²K',
  fromBase: {'W/m²K': (u) => u * power['W'] / area['m²'] / temperature['K']},
);

final units = [
  time,
  length,
  mass,
  temperature,
  velocity,
  acceleration,
  force,
  energy,
  power,
  area,
  volume,
  arealDensity,
  density,
  wValue,
  uValue,
];

typedef UnitConverter = Map<String, num Function(num)>;

class Unit {
  Unit({
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
}
