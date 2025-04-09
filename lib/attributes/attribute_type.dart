import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

const attributeTypes = AttributeType.values;

enum AttributeType {
  text,
  number;

  static AttributeType fromJson(dynamic json) {
    return AttributeType.values.firstWhere((e) => e.name == json);
  }

  String toJson() => name;
}

extension AttributeTypeExtension on AttributeType {
  IconData icon() {
    return switch (this) {
      AttributeType.text => Symbols.abc,
      AttributeType.number => Symbols.onetwothree, // Symbols.numbers,
      // _ => Symbols.change_history,
    };
  }
}
