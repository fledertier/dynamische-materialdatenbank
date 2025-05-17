import 'dart:math';

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

double widthByColumns(int columns) {
  return columns * 158 + (columns - 1) * 16;
}

extension SizeExtension on Size {
  double get area => width * height;
}

extension MenuControllerExtension on MenuController {
  void toggle() => isOpen ? close() : open();
}

extension RandomColor on Color {
  static Color rgb() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
