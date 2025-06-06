import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';

dynamic getAttributeValue(
  Json material,
  Map<String, Attribute> attributesById,
  AttributePath path,
) {
  final json = getJsonAttributeValue(material, attributesById, path);
  final attribute = getAttribute(attributesById, path);

  return fromJson(json, attribute?.type);
}

dynamic getJsonAttributeValue(
  Json material,
  Map<String, Attribute>? attributesById,
  AttributePath path,
) {
  var attribute = attributesById?[path.ids.first];
  var value = material[path.ids.first];
  for (final id in path.ids.skip(1)) {
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
  AttributePath? path,
) {
  var attribute = attributesById?[path?.ids.first];
  for (final id in path?.ids.skip(1) ?? []) {
    attribute = attribute?.childAttributes.firstWhereOrNull(
      (attribute) => attribute.id == id,
    );
  }
  return attribute;
}

List<String>? getFullAttributeName(
  Map<String, Attribute>? attributesById,
  AttributePath? path,
) {
  var attribute = attributesById?[path?.ids.first];
  if (attribute == null) return null;

  String typeName(Attribute attribute) {
    return attribute.type.name.toTitleCase();
  }

  final name = [attribute.name ?? typeName(attribute)];

  for (final id in path?.ids.skip(1) ?? []) {
    attribute = attribute?.childAttributes.firstWhereOrNull(
      (attribute) => attribute.id == id,
    );
    // todo: for lists skip their child attribute
    if (attribute != null && attribute.type is! ObjectAttributeType) {
      name.add(attribute.name ?? typeName(attribute));
    }
  }
  return name;
}

AttributePath? toAttributePath(String? attributeId) {
  if (attributeId == null || attributeId.isEmpty) {
    return null;
  }
  return AttributePath(attributeId);
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
