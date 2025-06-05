import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/query/condition_node.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';

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
  Set<String> get attributes => {if (isValid) attribute!.split('.').first};

  @override
  bool matches(Json material, Map<String, Attribute> attributesById) {
    var value = getAttributeValue(material, attributesById, attribute!);
    value = switch (value) {
      TranslatableText() => value.valueDe,
      UnitNumber() => value.value,
      _ => value,
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
