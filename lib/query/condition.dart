import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/foundation.dart';

import '../attributes/attribute_type.dart';
import '../types.dart';

enum ConditionGroupType { and, or }

extension ConditionGroupTypeExtension on ConditionGroupType {
  ConditionGroupType get other {
    return this == ConditionGroupType.and
        ? ConditionGroupType.or
        : ConditionGroupType.and;
  }
}

abstract class ConditionNode {
  const ConditionNode();

  bool get isValid;

  Set<String> get attributes;

  bool matches(Material material);
}

class ConditionGroup extends ConditionNode {
  ConditionGroup({required this.type, required this.nodes});

  ConditionGroupType type;
  List<ConditionNode> nodes;

  @override
  bool get isValid {
    return nodes.isNotEmpty;
  }

  @override
  Set<String> get attributes {
    return nodes.expand((node) => node.attributes).toSet();
  }

  @override
  bool matches(Material material) {
    final validNodes = nodes.where((node) => node.isValid);
    return switch (type) {
      ConditionGroupType.and => validNodes.every(
        (node) => node.matches(material),
      ),
      ConditionGroupType.or => validNodes.any((node) => node.matches(material)),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConditionGroup) return false;
    return type == other.type && listEquals(nodes, other.nodes);
  }

  @override
  int get hashCode {
    return type.hashCode ^ nodes.hashCode;
  }

  @override
  String toString() {
    return 'ConditionGroup(type: $type, nodes: $nodes)';
  }
}

class Condition extends ConditionNode {
  Condition({this.attribute, this.operator, this.parameter});

  String? attribute;
  Operator? operator;
  Object? parameter;

  @override
  bool get isValid {
    return attribute != null && operator != null && parameter != null;
  }

  @override
  Set<String> get attributes => {if (isValid) attribute!};

  @override
  bool matches(Material material) {
    final value = material[attribute!];
    if (value == null) {
      return false;
    }
    return switch (operator!) {
      Operator.equals => value == parameter,
      Operator.notEquals => value != parameter,
      Operator.greaterThan => value > parameter,
      Operator.lessThan => value < parameter,
      Operator.contains => value.toString().containsIgnoreCase(
        parameter.toString(),
      ),
      Operator.notContains =>
        !value.toString().containsIgnoreCase(parameter.toString()),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Condition) return false;
    return attribute == other.attribute &&
        operator == other.operator &&
        parameter == other.parameter;
  }

  @override
  int get hashCode {
    return Object.hash(attribute, operator, parameter);
  }

  @override
  String toString() {
    return 'Condition(attribute: $attribute, operator: $operator, parameter: $parameter)';
  }
}
