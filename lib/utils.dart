import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:uuid/uuid.dart';

String generateId() {
  return Uuid().v7();
}

extension StringExtension on String {
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}

extension MapExtension<K, V> on Map<K, V> {
  Map<T, V> mapKeys<T>(T Function(K key) convert) {
    return map((key, value) => MapEntry(convert(key), value));
  }

  Map<K, T> mapValues<T>(T Function(V value) convert) {
    return map((key, value) => MapEntry(key, convert(value)));
  }

  Map<K, V> whereKeys(bool Function(K key) test) {
    return where((key, _) => test(key));
  }

  Map<K, V> whereValues(bool Function(V value) test) {
    return where((_, value) => test(value));
  }

  Map<K, V> where(bool Function(K key, V value) test) {
    final result = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }
}

extension EnumByName<T extends Enum> on Iterable<T> {
  T? maybeByName(String? name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}

double widthByColumns(int columns) {
  return columns * 158 + (columns - 1) * 16;
}

extension SizeExtension on Size {
  double get area => width * height;
}

UnitType? unitTypeFromName(String? name) {
  return unitTypes.singleWhereOrNull((unit) => unit.name == name);
}
