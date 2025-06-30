import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:dynamische_materialdatenbank/query/condition_node.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';

extension ConditionGroupConverter on ConditionGroup {
  static ConditionGroup? maybeFromJson(
    Json? json,
    Map<String, Attribute>? attributesById,
  ) {
    if (json == null) {
      return null;
    }
    final type = ConditionGroupTypeConverter.maybeFromJson(json['type']);
    if (type == null) {
      return null;
    }
    final nodes = ConditionNodeListConverter.maybeFromJson(
      json['nodes'],
      attributesById,
    );
    if (nodes == null) {
      return null;
    }
    return ConditionGroup(type: type, nodes: nodes);
  }
}

extension ConditionGroupTypeConverter on ConditionGroupType {
  static ConditionGroupType? maybeFromJson(String? name) {
    if (name == null) {
      return null;
    }
    return ConditionGroupType.values.maybeByName(name);
  }
}

extension ConditionNodeListConverter on List<ConditionNode> {
  static List<ConditionNode>? maybeFromJson(
    List<dynamic>? json,
    Map<String, Attribute>? attributesById,
  ) {
    if (json == null) {
      return null;
    }
    return json
        .map(
          (json) => ConditionNodeConverter.maybeFromJson(json, attributesById),
        )
        .whereType<ConditionNode>()
        .toList();
  }
}

extension ConditionNodeConverter on ConditionNode {
  static ConditionNode? maybeFromJson(
    Json? json,
    Map<String, Attribute>? attributesById,
  ) {
    if (json == null) {
      return null;
    }
    if (json.containsKey('type')) {
      return ConditionGroupConverter.maybeFromJson(json, attributesById);
    }
    return ConditionConverter.maybeFromJson(json, attributesById);
  }
}

extension ConditionConverter on Condition {
  static Condition? maybeFromJson(
    Json? json,
    Map<String, Attribute>? attributesById,
  ) {
    if (json == null) {
      return null;
    }

    final operator = Operator.values.maybeByName(json['operator']);

    final attribute = json['attribute'] as String?;
    if (attribute == null) {
      return Condition(
        attributePath: null,
        operator: operator,
        parameter: null,
      );
    }

    final attributePath = AttributePath(attribute);
    final attributeType = getAttribute(attributesById, attributePath)?.type;
    final condition = Condition(
      attributePath: attributePath,
      operator: Operator.values.maybeByName(json['operator']),
      parameter: fromJson(json['parameter'] as Json?, attributeType),
    );

    return condition.isValid ? condition : null;
  }
}
