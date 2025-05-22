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
    final type = attribute?.type as ObjectAttributeType?;
    attribute = type?.attributes.firstWhereOrNull(
      (attribute) => attribute.id == id,
    );
  }
  return attribute;
}

dynamic getAttributeValue(
  Json material,
  Map<String, Attribute> attributesById,
  String attributeId,
) {
  final ids = attributeId.split('.');
  var attribute = attributesById[ids.firstOrNull];
  var value = material[ids.firstOrNull];
  for (final id in ids.skip(1)) {
    final type = attribute?.type as ObjectAttributeType?;
    attribute = type?.attributes.firstWhereOrNull(
      (attribute) => attribute.id == id,
    );
    value = value?[id];
  }
  return switch (attribute?.type) {
    TextAttributeType() => value?['valueDe'],
    NumberAttributeType() => value?['value'],
    _ => value,
  };
}
