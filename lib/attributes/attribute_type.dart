import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum Operator {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  contains,
  notContains;

  static Operator fromJson(dynamic json) {
    return Operator.values.byName(json);
  }

  String toJson() => name;
}

enum AttributeType {
  text(
    operators: {
      Operator.contains,
      Operator.notContains,
      Operator.equals,
      Operator.notEquals,
    },
  ),
  textarea(
    operators: {
      Operator.contains,
      Operator.notContains,
      Operator.equals,
      Operator.notEquals,
    },
  ),
  number(
    operators: {
      Operator.greaterThan,
      Operator.lessThan,
      Operator.equals,
      Operator.notEquals,
    },
  ),
  boolean(
    operators: {
      Operator.equals,
    },
  );

  final Set<Operator> operators;

  const AttributeType({required this.operators});

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
