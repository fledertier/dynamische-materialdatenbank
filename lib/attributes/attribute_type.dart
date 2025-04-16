import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum Operation {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  contains,
  notContains;

  static Operation fromJson(dynamic json) {
    return Operation.values.byName(json);
  }

  String toJson() => name;
}

enum AttributeType {
  text(
    allowedOperations: {
      Operation.contains,
      Operation.notContains,
      Operation.equals,
      Operation.notEquals,
    },
  ),
  textarea(
    allowedOperations: {
      Operation.contains,
      Operation.notContains,
      Operation.equals,
      Operation.notEquals,
    },
  ),
  number(
    allowedOperations: {
      Operation.greaterThan,
      Operation.lessThan,
      Operation.equals,
      Operation.notEquals,
    },
  ),
  boolean(
    allowedOperations: {
      Operation.equals,
    },
  );

  final Set<Operation> allowedOperations;

  const AttributeType({required this.allowedOperations});

  static AttributeType fromJson(dynamic json) {
    return AttributeType.values.byName(json);
  }

  String toJson() => name;
}

extension AttributeTypeExtension on AttributeType {
  IconData get icon {
    return switch (this) {
      AttributeType.text => Symbols.text_fields,
      AttributeType.textarea => Symbols.article,
      AttributeType.number => Symbols.numbers,
      AttributeType.boolean => Symbols.toggle_on,
      // _ => Symbols.change_history,
    };
  }
}
