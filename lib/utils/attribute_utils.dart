import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/types.dart';

dynamic getAttributeValue(
  Json material,
  Map<String, Attribute>? attributesById,
  String attributeId,
) {
  final json = getJsonAttributeValue(material, attributesById, attributeId);
  final attribute = getAttribute(attributesById, attributeId);

  return fromJson(json, attribute?.type);
}

dynamic getJsonAttributeValue(
  Json material,
  Map<String, Attribute>? attributesById,
  String attributeId,
) {
  final ids = attributeId.split('.');
  var attribute = attributesById?[ids.firstOrNull];
  var value = material[ids.firstOrNull];
  for (final id in ids.skip(1)) {
    attribute = attribute?.childAttributes.firstWhereOrNull(
      (attribute) => attribute.id == id,
    );
    if (value is List) {
      value = value.map((item) => item[id]).toList();
    } else {
      value = value?[id];
    }
  }
  return value;
}

Attribute? getAttribute(
  Map<String, Attribute>? attributesById,
  String? attributeId,
) {
  final ids = attributeId?.split('.') ?? [];
  var attribute = attributesById?[ids.firstOrNull];
  for (final id in ids.skip(1)) {
    attribute = attribute?.childAttributes.firstWhereOrNull(
      (attribute) => attribute.id == id,
    );
  }
  return attribute;
}

extension AttributeChildExtension on Attribute {
  List<Attribute> get childAttributes {
    if (type case ObjectAttributeType(:final attributes)) {
      return attributes;
    } else if (type case ListAttributeType(:final attribute)) {
      return [attribute];
    }
    return [];
  }
}

extension AttributeIdExtension on String {
  String get topLevel => split('.').first;

  int get levels => split('.').length;

  String add(String id) {
    return [this, id].join('.');
  }
}
