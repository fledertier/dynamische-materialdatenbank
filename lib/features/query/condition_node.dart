import 'package:dynamische_materialdatenbank/features/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attribute_converter.dart';

abstract class ConditionNode {
  const ConditionNode();

  bool get isValid;

  Set<String> get attributeIds;

  bool matches(Json material, Map<String, Attribute> attributesById);
}
