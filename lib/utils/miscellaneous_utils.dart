import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

String generateId() {
  return Uuid().v7();
}

extension EnumByName<T extends Enum> on Iterable<T> {
  T? maybeByName(String? name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}

UnitType? unitTypeFromName(String? name) {
  return UnitTypes.values.singleWhereOrNull((unit) => unit.name == name);
}

double widthByColumns(int columns) {
  return columns * 158 + (columns - 1) * 16;
}

extension SizeExtension on Size {
  double get area => width * height;
}

extension MenuControllerExtension on MenuController {
  void toggle() => isOpen ? close() : open();
}
