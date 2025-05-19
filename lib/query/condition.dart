import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';

import 'condition_node.dart';

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
  bool matches(Json material, Map<String, Attribute> attributesById) {
    final type = attributesById[attribute!]?.type;
    final value = switch (type) {
      NumberAttributeType() => material[attribute!]?['value'],
      _ => material[attribute!],
    };
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
    return other is Condition &&
        attribute == other.attribute &&
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
