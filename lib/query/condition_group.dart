import 'package:flutter/foundation.dart';

import '../types.dart';
import 'condition_node.dart';

enum ConditionGroupType { and, or }

extension ConditionGroupTypeExtension on ConditionGroupType {
  ConditionGroupType get other {
    return this == ConditionGroupType.and
        ? ConditionGroupType.or
        : ConditionGroupType.and;
  }
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
  bool matches(Json material) {
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
    return Object.hash(type, Object.hashAll(nodes));
  }

  @override
  String toString() {
    return 'ConditionGroup(type: $type, nodes: $nodes)';
  }
}
