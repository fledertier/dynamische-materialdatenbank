import '../attributes/attribute_type.dart';

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
}

class ConditionGroup extends ConditionNode {
  ConditionGroup({required this.type, required this.nodes});

  ConditionGroupType type;
  List<ConditionNode> nodes;
}

class Condition extends ConditionNode {
  String? attribute;
  Operator? operator;
  Object? parameter;

  Condition({this.attribute, this.operator, this.parameter});

  bool get isValid {
    return attribute != null && operator != null && parameter != null;
  }
}
