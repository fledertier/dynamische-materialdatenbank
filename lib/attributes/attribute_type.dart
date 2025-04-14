import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

const attributeTypes = AttributeType.values;

enum AttributeType {
  text,
  number,
  boolean;

  static AttributeType fromJson(dynamic json) {
    return AttributeType.values.firstWhere((e) => e.name == json);
  }

  String toJson() => name;
}

extension AttributeTypeExtension on AttributeType {
  IconData get icon {
    return switch (this) {
      AttributeType.text => Symbols.text_fields,
      AttributeType.number => Symbols.numbers,
      AttributeType.boolean => Symbols.toggle_on,
      // _ => Symbols.change_history,
    };
  }
}
