import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
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
  boolean(operators: {Operator.equals}),
  object(operators: {Operator.equals, Operator.notEquals}),
  list(
    operators: {
      Operator.equals,
      Operator.notEquals,
      Operator.contains,
      Operator.notContains,
    },
  ),
  proportions(operators: {Operator.contains, Operator.notContains}),
  countedTags(operators: {Operator.contains, Operator.notContains}),
  countries(operators: {Operator.contains, Operator.notContains});

  final Set<Operator> operators;

  const AttributeType({required this.operators});

  static AttributeType fromJson(dynamic json) {
    return AttributeType.values.byName(json);
  }

  static AttributeType? maybeFromJson(dynamic json) {
    return AttributeType.values.maybeByName(json);
  }

  String toJson() => name;
}

extension AttributeTypeExtension on AttributeType {
  IconData get icon {
    return switch (this) {
      AttributeType.text => Symbols.text_fields,
      AttributeType.textarea => Symbols.article,
      AttributeType.number => Symbols.numbers,
      AttributeType.boolean => Symbols.check_box,
      AttributeType.proportions => Symbols.pie_chart,
      AttributeType.countedTags => Symbols.voting_chip,
      AttributeType.countries => Symbols.public,
      AttributeType.object => Symbols.category,
      AttributeType.list => Symbols.menu,
      // _ => Symbols.change_history,
    };
  }
}
