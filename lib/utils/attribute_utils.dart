import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/types.dart';

Attribute? getAttribute(
  Map<String, Attribute>? attributesById,
  String? attributeId,
) {
  final ids = attributeId?.split('.') ?? [];
  var attribute = attributesById?[ids.firstOrNull];
  for (final id in ids.skip(1)) {
    final type = attribute?.type;
    if (type == null) {
      return null;
    } else if (type is ObjectAttributeType) {
      attribute = type.attributes.firstWhereOrNull(
        (attribute) => attribute.id == id,
      );
    } else if (type is ListAttributeType) {
      attribute = type.attribute;
    }
  }
  return attribute;
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
    final type = attribute?.type as ObjectAttributeType?;
    attribute = type?.attributes.firstWhereOrNull(
      (attribute) => attribute.id == id,
    );
    value = value?[id];
  }
  return value;
}

extension AttributeIdExtension on String {
  String get topLevel => split('.').first;

  String add(String id) {
    return [this, id].join('.');
  }
}
