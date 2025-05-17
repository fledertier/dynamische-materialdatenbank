import 'package:collection/collection.dart';
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

class AttributeType {
  static const text = AttributeType(
    id: 'text',
    operators: {
      Operator.contains,
      Operator.notContains,
      Operator.equals,
      Operator.notEquals,
    },
  );
  static const textarea = AttributeType(
    id: 'textarea',
    operators: {
      Operator.contains,
      Operator.notContains,
      Operator.equals,
      Operator.notEquals,
    },
  );
  static const number = AttributeType(
    id: 'number',
    operators: {
      Operator.greaterThan,
      Operator.lessThan,
      Operator.equals,
      Operator.notEquals,
    },
  );
  static const boolean = AttributeType(
    id: 'boolean',
    operators: {Operator.equals},
  );
  static const object = AttributeType(
    id: 'object',
    operators: {Operator.equals, Operator.notEquals},
  );
  static const list = AttributeType(
    id: 'list',
    operators: {
      Operator.equals,
      Operator.notEquals,
      Operator.contains,
      Operator.notContains,
    },
  );
  static const proportions = AttributeType(
    id: 'proportions',
    operators: {Operator.contains, Operator.notContains},
  );
  static const countedTags = AttributeType(
    id: 'countedTags',
    operators: {Operator.contains, Operator.notContains},
  );
  static const countries = AttributeType(
    id: 'countries',
    operators: {Operator.contains, Operator.notContains},
  );

  static final values = [
    text,
    textarea,
    number,
    boolean,
    object,
    list,
    proportions,
    countedTags,
    countries,
  ];
  
  final String id;
  final Set<Operator> operators;

  String get name => id;

  const AttributeType({required this.id, required this.operators});

  static AttributeType fromJson(dynamic json) {
    return AttributeType.values.singleWhere((type) => type.id == json);
  }

  static AttributeType? maybeFromJson(dynamic json) {
    return AttributeType.values.singleWhereOrNull((type) => type.id == json);
  }

  String toJson() => id;
}

extension AttributeTypeExtension on AttributeType {
  IconData get icon {
    return switch (id) {
      'text' => Symbols.text_fields,
      'textarea' => Symbols.article,
      'number' => Symbols.numbers,
      'boolean' => Symbols.check_box,
      'proportions' => Symbols.pie_chart,
      'countedTags' => Symbols.voting_chip,
      'countries' => Symbols.public,
      'object' => Symbols.category,
      'list' => Symbols.menu,
      _ => Symbols.change_history,
    };
  }
}
