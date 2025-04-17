import 'package:dynamische_materialdatenbank/custom_search/where_clause.dart';
import 'package:flutter/cupertino.dart';

import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';

class WhereClauseController extends ValueNotifier<WhereClauseValue> {
  WhereClauseController()
      : super(
    const WhereClauseValue(
      attribute: null,
      operator: null,
      parameter: null,
    ),
  );

  Attribute? get attribute => value.attribute;

  set attribute(Attribute? attribute) {
    value = value.copyWith(attribute: () => attribute);
  }

  Operator? get operator => value.operator;

  set operator(Operator? operator) {
    value = value.copyWith(operator: () => operator);
  }

  Object? get parameter => value.parameter;

  set parameter(Object? parameter) {
    value = value.copyWith(parameter: () => parameter);
  }

  WhereClause toWhereClause() {
    return WhereClause(
      attribute: attribute!,
      operator: operator!,
      parameter: parameter!,
    );
  }
}

class WhereClauseValue {
  final Attribute? attribute;
  final Operator? operator;
  final Object? parameter;

  const WhereClauseValue({this.attribute, this.operator, this.parameter});

  WhereClauseValue copyWith({
    Attribute? Function()? attribute,
    Operator? Function()? operator,
    Object? Function()? parameter,
  }) {
    return WhereClauseValue(
      attribute: attribute != null ? attribute() : this.attribute,
      operator: operator != null ? operator() : this.operator,
      parameter: parameter != null ? parameter() : this.parameter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WhereClauseValue &&
        other.attribute == attribute &&
        other.operator == operator &&
        other.parameter == parameter;
  }

  @override
  int get hashCode {
    return attribute.hashCode ^ operator.hashCode ^ parameter.hashCode;
  }

  @override
  String toString() {
    return 'WhereClauseValue(attribute: $attribute, operator: $operator, parameter: $parameter)';
  }
}
