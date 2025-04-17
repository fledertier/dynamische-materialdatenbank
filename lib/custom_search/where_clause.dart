import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';

class WhereClause {
  final Attribute attribute;
  final Operator operator;
  final Object parameter;

  const WhereClause({
    required this.attribute,
    required this.operator,
    required this.parameter,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WhereClause &&
        other.attribute == attribute &&
        other.operator == operator &&
        other.parameter == parameter;
  }

  @override
  int get hashCode {
    return attribute.hashCode ^ operator.hashCode ^ parameter.hashCode;
  }
}
