import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';

enum ConditionGroupType { and, or }

extension LogicalOperatorExtension on ConditionGroupType {
  ConditionGroupType get other {
    return this == ConditionGroupType.and
        ? ConditionGroupType.or
        : ConditionGroupType.and;
  }
}

abstract class ConditionNode {
  const ConditionNode();
}

class ConditionGroup extends ConditionNode {
  ConditionGroup({required this.type, required this.nodes});

  ConditionGroupType type;
  List<ConditionNode> nodes;
}

class Condition extends ConditionNode {
  final Attribute? attribute;
  final Comparator? comparator;
  final Object? parameter;

  const Condition({this.attribute, this.comparator, this.parameter});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Condition &&
        other.attribute == attribute &&
        other.comparator == comparator &&
        other.parameter == parameter;
  }

  @override
  int get hashCode {
    return attribute.hashCode ^ comparator.hashCode ^ parameter.hashCode;
  }
}
