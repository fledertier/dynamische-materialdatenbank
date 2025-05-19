import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'attribute.dart';

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

  @override
  dynamic getValue(Json material, List<String> attribute) {
    return material[attribute.first]?['value'];
  }

  factory NumberAttributeType.fromJson(Json json) {
    return NumberAttributeType(
      unitType: UnitType.maybeFromJson(json['unitType']),
    );
  }

  @override
  Json toJson() {
    return {'id': id, 'unitType': unitType?.toJson()};
  }

  @override
  String toString() => [name, unitType].nonNulls.join(', ');

  @override
  int get hashCode => Object.hash(id, unitType);

  @override
  bool operator ==(Object other) {
    return other is NumberAttributeType &&
        other.id == id &&
        other.unitType == unitType;
  }
}

class BooleanAttributeType extends AttributeType {
  BooleanAttributeType()
    : super(id: AttributeType.boolean, operators: {Operator.equals});

  factory BooleanAttributeType.fromJson(Json json) {
    return BooleanAttributeType();
  }
}

class UrlAttributeType extends AttributeType {
  UrlAttributeType()
    : super(
        id: AttributeType.url,
        operators: {Operator.equals, Operator.notEquals},
      );

  factory UrlAttributeType.fromJson(Json json) {
    return UrlAttributeType();
  }
}

class ObjectAttributeType extends AttributeType {
  ObjectAttributeType({required this.attributes})
    : super(
        id: AttributeType.object,
        operators: {Operator.equals, Operator.notEquals},
      );

  final List<Attribute> attributes;

  @override
  dynamic getValue(Json material, List<String> attribute) {
    return attributes
        .firstWhereOrNull((attr) => attr.id == attribute.first)
        ?.type
        .getValue(material, attribute.sublist(1));
  }

  factory ObjectAttributeType.fromJson(Json json) {
    final attributes =
        List<Json>.from(json['attributes']).map(Attribute.fromJson).toList();
    return ObjectAttributeType(attributes: attributes);
  }

  @override
  Json toJson() {
    return {
      'id': id,
      'attributes': attributes.map((attribute) => attribute.toJson()).toList(),
    };
  }

  @override
  String toString() => '$name, ${attributes.length} attributes';

  @override
  int get hashCode => Object.hash(id, Object.hashAll(attributes));

  @override
  bool operator ==(Object other) {
    return other is ObjectAttributeType &&
        other.id == id &&
        listEquals(other.attributes, attributes);
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

  @override
  String toString() => '$name, $type';

  @override
  int get hashCode => Object.hash(id, type);

  @override
  bool operator ==(Object other) {
    return other is ListAttributeType && other.id == id && other.type == type;
  }
}

class CountryAttributeType extends AttributeType {
  CountryAttributeType()
    : super(
        id: AttributeType.country,
        operators: {Operator.equals, Operator.notEquals},
      );

  factory CountryAttributeType.fromJson(Json json) {
    return CountryAttributeType();
  }
}

abstract class AttributeType {
  static const text = 'text';
  static const textarea = 'textarea';
  static const number = 'number';
  static const boolean = 'boolean';
  static const url = 'url';
  static const country = 'country';
  static const object = 'object';
  static const list = 'list';

  static final values = [
    text,
    textarea,
    number,
    boolean,
    url,
    country,
    object,
    list,
  ];

  const AttributeType({required this.id, required this.operators});

  final String id;
  final Set<Operator> operators;

  String get name => id;

  dynamic getValue(Json material, List<String> attribute) {
    return material[attribute.first];
  }

  factory AttributeType.fromJson(Json json) {
    final id = json['id'];
    return switch (id) {
      text => TextAttributeType.fromJson(json),
      textarea => TextareaAttributeType.fromJson(json),
      number => NumberAttributeType.fromJson(json),
      boolean => BooleanAttributeType.fromJson(json),
      url => UrlAttributeType.fromJson(json),
      country => CountryAttributeType.fromJson(json),
      object => ObjectAttributeType.fromJson(json),
      list => ListAttributeType.fromJson(json),
      _ =>
        throw UnimplementedError(
          'AttributeType $id is missing fromJson method',
        ),
    };
  }

  Json toJson() => {'id': id};

  @override
  String toString() => name;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is AttributeType && other.id == id;
  }
}

IconData iconForAttributeType(String id) {
  return switch (id) {
    AttributeType.text => Symbols.text_fields,
    AttributeType.textarea => Symbols.article,
    AttributeType.number => Symbols.numbers,
    AttributeType.boolean => Symbols.check_box,
    AttributeType.url => Symbols.link,
    AttributeType.country => Symbols.language,
    AttributeType.object => Symbols.category,
    AttributeType.list => Symbols.menu,
    _ => Symbols.change_history,
  };
}
