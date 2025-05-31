import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/types.dart';

import '../material/attribute/default/country/country.dart';
import '../material/attribute/default/number/unit_number.dart';
import '../material/attribute/default/text/translatable_text.dart';

dynamic fromJson(dynamic json, AttributeType? type) {
  if (json == null || type == null) {
    return null;
  }
  return switch (type) {
    TextAttributeType() => TranslatableText.fromJson(json),
    NumberAttributeType() => UnitNumber.fromJson(json),
    BooleanAttributeType() => json as bool,
    CountryAttributeType() => Country.fromJson(json),
    UrlAttributeType() => Uri.tryParse(json as String),
    ListAttributeType() => listFromJson(json, type),
    ObjectAttributeType() => objectFromJson(json, type),
    _ =>
      throw UnimplementedError(
        "fromJson() for attribute type '$type' not implemented",
      ),
  };
}

List listFromJson(List json, ListAttributeType type) {
  final itemType = type.attribute.type;
  return json.map((json) => fromJson(json, itemType)).toList();
}

Json objectFromJson(Json json, ObjectAttributeType type) {
  final attributes = type.attributes;
  final object = Json();

  for (final attribute in attributes) {
    final value = json[attribute.id];
    object[attribute.id] = fromJson(value, attribute.type);
  }
  return object;
}

dynamic toJson(dynamic value, AttributeType type) {
  if (value == null) {
    return null;
  }
  return switch (type) {
    TextAttributeType() => (value as TranslatableText).toJson(),
    NumberAttributeType() => (value as UnitNumber).toJson(),
    BooleanAttributeType() => value as bool,
    CountryAttributeType() => (value as Country).toJson(),
    UrlAttributeType() => (value as Uri).toString(),
    ListAttributeType() => listToJson(value as List, type),
    ObjectAttributeType() => objectToJson(value as Json, type),
    _ =>
      throw UnimplementedError(
        "toJson() for attribute type '$type' not implemented",
      ),
  };
}

List listToJson(List list, ListAttributeType type) {
  final itemType = type.attribute.type;
  return list.map((value) => toJson(value, itemType)).toList();
}

Json objectToJson(Json object, ObjectAttributeType type) {
  final attributes = type.attributes;
  final json = Json();

  for (final attribute in attributes) {
    final value = object[attribute.id];
    json[attribute.id] = toJson(value, attribute.type);
  }
  return json;
}
