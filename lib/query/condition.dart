import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/query/condition_node.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';

class Condition extends ConditionNode {
  Condition({this.attributePath, this.operator, this.parameter});

  AttributePath? attributePath;
  Operator? operator;
  Object? parameter;

  @override
  bool get isValid {
    return attributePath != null && operator != null && parameter != null;
  }

  @override
  Set<String> get attributeIds => {if (isValid) attributePath!.topLevelId};

  @override
  bool matches(Json material, Map<String, Attribute> attributesById) {
    var value = getAttributeValue(material, attributesById, attributePath!);
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
        attributePath == other.attributePath &&
        operator == other.operator &&
        parameter == other.parameter;
  }

  @override
  int get hashCode {
    return Object.hash(attributePath, operator, parameter);
  }

  @override
  String toString() {
    return 'Condition(attributePath: $attributePath, operator: $operator, parameter: $parameter)';
  }
}
