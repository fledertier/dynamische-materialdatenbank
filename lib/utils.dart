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
