import 'package:uuid/uuid.dart';

String generateId() {
  return Uuid().v7();
}

extension StringExtension on String {
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}

extension EnumByName<T extends Enum> on Iterable<T> {
  T byName(String name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    throw ArgumentError.value(name, "name", "No enum value with that name");
  }

  T? maybeByName(String? name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}
