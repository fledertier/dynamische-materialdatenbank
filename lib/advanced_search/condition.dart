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
  final String? attribute;
  final Operator? operator;
  final Object? parameter;

  const Condition({this.attribute, this.operator, this.parameter});

  bool get isValid {
    return attribute != null && operator != null && parameter != null;
  }

  Condition copyWith({
    String? Function()? attribute,
    Operator? Function()? operator,
    Object? Function()? parameter,
  }) {
    return Condition(
      attribute: attribute != null ? attribute() : this.attribute,
      operator: operator != null ? operator() : this.operator,
      parameter: parameter != null ? parameter() : this.parameter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Condition &&
        other.attribute == attribute &&
        other.operator == operator &&
        other.parameter == parameter;
  }

  @override
  int get hashCode {
    return Object.hash(attribute, operator, parameter);
  }
}
