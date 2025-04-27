import 'package:collection/collection.dart';

import '../attributes/attribute_type.dart';
import '../types.dart';
import 'condition.dart';
import 'condition_group.dart';
import 'condition_node.dart';

extension ConditionGroupConverter on ConditionGroup {
  static ConditionGroup? maybeFromJson(Json? json) {
    if (json == null) {
      return null;
    }
    final type = ConditionGroupTypeConverter.maybeFromJson(json['type']);
    if (type == null) {
      return null;
    }
    final nodes = ConditionNodeListConverter.maybeFromJson(json['nodes']);
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
    return ConditionGroupType.values.firstWhereOrNull(
      (type) => type.name == name,
    );
  }
}

extension ConditionNodeListConverter on List<ConditionNode> {
  static List<ConditionNode>? maybeFromJson(List<dynamic>? json) {
    if (json == null) {
      return null;
    }
    return json
        .map((json) => ConditionNodeConverter.maybeFromJson(json))
        .whereType<ConditionNode>()
        .toList();
  }
}

extension ConditionNodeConverter on ConditionNode {
  static ConditionNode? maybeFromJson(Json? json) {
    if (json == null) {
      return null;
    }
    if (json.containsKey("type")) {
      return ConditionGroupConverter.maybeFromJson(json);
    }
    return ConditionConverter.maybeFromJson(json);
  }
}

extension ConditionConverter on Condition {
  static Condition? maybeFromJson(Json? json) {
    if (json == null) {
      return null;
    }
    final attribute = json['attribute'] as String?;
    final operator = OperatorConverter.maybeFromJson(json['operator']);
    final parameter = json['parameter'];

    if (attribute == null || operator == null || parameter == null) {
      return null;
    }
    return Condition(
      attribute: attribute,
      operator: operator,
      parameter: parameter,
    );
  }
}

extension OperatorConverter on Operator {
  static Operator? maybeFromJson(String? name) {
    if (name == null) {
      return null;
    }
    return Operator.values.firstWhereOrNull(
      (operator) => operator.name == name,
    );
  }
}
