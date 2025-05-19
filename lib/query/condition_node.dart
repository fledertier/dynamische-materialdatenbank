import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/types.dart';

abstract class ConditionNode {
  const ConditionNode();

  bool get isValid;

  Set<String> get attributes;

  bool matches(Json material, Map<String, Attribute> attributesById);
}
