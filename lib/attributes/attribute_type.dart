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
    baseType: 'String',
    operators: {
      Operator.contains,
      Operator.notContains,
      Operator.equals,
      Operator.notEquals,
    },
  ),
  textarea(
    baseType: 'String',
    operators: {
      Operator.contains,
      Operator.notContains,
      Operator.equals,
      Operator.notEquals,
    },
  ),
  number(
    baseType: 'double',
    operators: {
      Operator.greaterThan,
      Operator.lessThan,
      Operator.equals,
      Operator.notEquals,
    },
  ),
  boolean(baseType: 'bool', operators: {Operator.equals}),
  proportions(operators: {Operator.contains, Operator.notContains}),
  countedTags(operators: {Operator.contains, Operator.notContains}),
  countries(operators: {Operator.contains, Operator.notContains});

  final String? baseType;
  final Set<Operator> operators;

  const AttributeType({this.baseType, required this.operators});

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
      AttributeType.proportions => Symbols.pie_chart,
      AttributeType.countedTags => Symbols.voting_chip,
      AttributeType.countries => Symbols.public,
      // _ => Symbols.change_history,
    };
  }

  bool get hasExchangeableTypes {
    return exchangeableTypes.length > 1;
  }

  List<AttributeType> get exchangeableTypes {
    if (baseType == null) {
      return [this];
    }
    return AttributeType.values
        .where((value) => value.baseType == baseType)
        .toList();
  }
}
