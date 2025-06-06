import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/query/condition_node.dart';
import 'package:flutter/foundation.dart';

enum ConditionGroupType { and, or }

extension ConditionGroupTypeExtension on ConditionGroupType {
  ConditionGroupType get other {
    return this == ConditionGroupType.and
        ? ConditionGroupType.or
        : ConditionGroupType.and;
  }
}

class ConditionGroup extends ConditionNode {
  ConditionGroup.and(List<ConditionNode> nodes)
    : this(type: ConditionGroupType.and, nodes: nodes);

  ConditionGroup.or(List<ConditionNode> nodes)
    : this(type: ConditionGroupType.or, nodes: nodes);

  ConditionGroup({required this.type, required this.nodes});

  ConditionGroupType type;
  List<ConditionNode> nodes;

  @override
  bool get isValid {
    return nodes.isNotEmpty;
  }

  @override
  Set<String> get attributeIds {
    return nodes.expand((node) => node.attributeIds).toSet();
  }

  @override
  bool matches(Json material, Map<String, Attribute> attributesById) {
    final validNodes = nodes.where((node) => node.isValid);
    return switch (type) {
      ConditionGroupType.and => validNodes.every(
        (node) => node.matches(material, attributesById),
      ),
      ConditionGroupType.or => validNodes.any(
        (node) => node.matches(material, attributesById),
      ),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is ConditionGroup &&
        type == other.type &&
        listEquals(nodes, other.nodes);
  }

  @override
  int get hashCode {
    return Object.hash(type, Object.hashAll(nodes));
  }

  @override
  String toString() {
    return 'ConditionGroup(type: $type, nodes: $nodes)';
  }
}
