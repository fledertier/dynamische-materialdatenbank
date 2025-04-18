import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum Comparator {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  contains,
  notContains;

  static Comparator fromJson(dynamic json) {
    return Comparator.values.byName(json);
  }

  String toJson() => name;
}

enum AttributeType {
  text(
    baseType: 'String',
    operators: {
      Comparator.contains,
      Comparator.notContains,
      Comparator.equals,
      Comparator.notEquals,
    },
  ),
  textarea(
    baseType: 'String',
    operators: {
      Comparator.contains,
      Comparator.notContains,
      Comparator.equals,
      Comparator.notEquals,
    },
  ),
  number(
    baseType: 'double',
    operators: {
      Comparator.greaterThan,
      Comparator.lessThan,
      Comparator.equals,
      Comparator.notEquals,
    },
  ),
  boolean(baseType: 'bool', operators: {Comparator.equals});

  final String baseType;
  final Set<Comparator> operators;

  const AttributeType({required this.baseType, required this.operators});

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

  bool get hasExchangeableTypes {
    return exchangeableTypes.length > 1;
  }

  List<AttributeType> get exchangeableTypes {
    return AttributeType.values
        .where((value) => value.baseType == baseType)
        .toList();
  }
}
