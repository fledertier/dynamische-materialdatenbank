import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/units.dart';
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

class TextAttributeType extends AttributeType {
  TextAttributeType()
    : super(
        id: AttributeType.text,
        operators: {
          Operator.contains,
          Operator.notContains,
          Operator.equals,
          Operator.notEquals,
        },
      );

  factory TextAttributeType.fromJson(Json json) {
    return TextAttributeType();
  }
}

class TextareaAttributeType extends AttributeType {
  TextareaAttributeType()
    : super(
        id: AttributeType.textarea,
        operators: {
          Operator.contains,
          Operator.notContains,
          Operator.equals,
          Operator.notEquals,
        },
      );

  factory TextareaAttributeType.fromJson(Json json) {
    return TextareaAttributeType();
  }
}

class NumberAttributeType extends AttributeType {
  NumberAttributeType({required this.unitType})
    : super(
        id: AttributeType.number,
        operators: {
          Operator.greaterThan,
          Operator.lessThan,
          Operator.equals,
          Operator.notEquals,
        },
      );

  final UnitType? unitType;

  factory NumberAttributeType.fromJson(Json json) {
    return NumberAttributeType(
      unitType: UnitType.maybeFromJson(json['unitType']),
    );
  }

  @override
  Json toJson() {
    return {'id': id, 'unitType': unitType?.toJson()};
  }
}

class BooleanAttributeType extends AttributeType {
  BooleanAttributeType()
    : super(id: AttributeType.boolean, operators: {Operator.equals});

  factory BooleanAttributeType.fromJson(Json json) {
    return BooleanAttributeType();
  }
}

class ObjectAttributeType extends AttributeType {
  ObjectAttributeType()
    : super(
        id: AttributeType.object,
        operators: {Operator.equals, Operator.notEquals},
      );

  factory ObjectAttributeType.fromJson(Json json) {
    return ObjectAttributeType();
  }
}

class ListAttributeType extends AttributeType {
  ListAttributeType({required this.type})
    : super(
        id: AttributeType.list,
        operators: {
          Operator.equals,
          Operator.notEquals,
          Operator.contains,
          Operator.notContains,
        },
      );

  final AttributeType type;

  factory ListAttributeType.fromJson(Json json) {
    return ListAttributeType(type: AttributeType.fromJson(json['type']));
  }

  @override
  Json toJson() {
    return {'id': id, 'type': type.toJson()};
  }
}

class ProportionsAttributeType extends AttributeType {
  ProportionsAttributeType()
    : super(
        id: AttributeType.proportions,
        operators: {Operator.contains, Operator.notContains},
      );

  factory ProportionsAttributeType.fromJson(Json json) {
    return ProportionsAttributeType();
  }
}

class CountedTagsAttributeType extends AttributeType {
  CountedTagsAttributeType()
    : super(
        id: AttributeType.countedTags,
        operators: {Operator.contains, Operator.notContains},
      );

  factory CountedTagsAttributeType.fromJson(Json json) {
    return CountedTagsAttributeType();
  }
}

class CountriesAttributeType extends AttributeType {
  CountriesAttributeType()
    : super(
        id: AttributeType.countries,
        operators: {Operator.contains, Operator.notContains},
      );

  factory CountriesAttributeType.fromJson(Json json) {
    return CountriesAttributeType();
  }
}

class AttributeType {
  static const text = 'text';
  static const textarea = 'textarea';
  static const number = 'number';
  static const boolean = 'boolean';
  static const object = 'object';
  static const list = 'list';
  static const proportions = 'proportions';
  static const countedTags = 'countedTags';
  static const countries = 'countries';

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

  const AttributeType({required this.id, required this.operators});

  final String id;
  final Set<Operator> operators;

  String get name => id;

  Json toJson() => {'id': id};

  static AttributeType fromJson(Json json) {
    final id = json['id'];
    return switch (id) {
      text => TextAttributeType.fromJson(json),
      textarea => TextareaAttributeType.fromJson(json),
      number => NumberAttributeType.fromJson(json),
      boolean => BooleanAttributeType.fromJson(json),
      object => ObjectAttributeType.fromJson(json),
      list => ListAttributeType.fromJson(json),
      proportions => ProportionsAttributeType.fromJson(json),
      countedTags => CountedTagsAttributeType.fromJson(json),
      countries => CountriesAttributeType.fromJson(json),
      _ =>
        throw UnimplementedError(
          'AttributeType $id is missing fromJson method',
        ),
    };
  }
}

IconData iconForAttributeType(String id) {
  return switch (id) {
    AttributeType.text => Symbols.text_fields,
    AttributeType.textarea => Symbols.article,
    AttributeType.number => Symbols.numbers,
    AttributeType.boolean => Symbols.check_box,
    AttributeType.proportions => Symbols.pie_chart,
    AttributeType.countedTags => Symbols.voting_chip,
    AttributeType.countries => Symbols.public,
    AttributeType.object => Symbols.category,
    AttributeType.list => Symbols.menu,
    _ => Symbols.change_history,
  };
}
