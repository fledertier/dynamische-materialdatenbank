import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:dynamische_materialdatenbank/query/condition_node.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';

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
    return ConditionGroupType.values.maybeByName(name);
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
    if (json.containsKey('type')) {
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

    final condition = Condition(
      attribute: json['attribute'] as String?,
      operator: Operator.values.maybeByName(json['operator']),
      parameter: json['parameter'],
    );

    return condition.isValid ? condition : null;
  }
}
