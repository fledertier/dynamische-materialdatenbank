import 'package:dynamische_materialdatenbank/advanced_search/where_clause.dart';
import 'package:flutter/cupertino.dart';

import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';

class WhereClauseController extends ValueNotifier<WhereClauseValue> {
  WhereClauseController()
    : super(
        const WhereClauseValue(
          attribute: null,
          comparator: null,
          parameter: null,
        ),
      );

  Attribute? get attribute => value.attribute;

  set attribute(Attribute? attribute) {
    value = value.copyWith(attribute: () => attribute);
  }

  Comparator? get comparator => value.comparator;

  set comparator(Comparator? comparator) {
    value = value.copyWith(comparator: () => comparator);
  }

  Object? get parameter => value.parameter;

  set parameter(Object? parameter) {
    value = value.copyWith(parameter: () => parameter);
  }

  WhereClause toWhereClause() {
    return WhereClause(
      attribute: attribute!,
      comparator: comparator!,
      parameter: parameter!,
    );
  }
}

class WhereClauseValue {
  final Attribute? attribute;
  final Comparator? comparator;
  final Object? parameter;

  const WhereClauseValue({this.attribute, this.comparator, this.parameter});

  WhereClauseValue copyWith({
    Attribute? Function()? attribute,
    Comparator? Function()? comparator,
    Object? Function()? parameter,
  }) {
    return WhereClauseValue(
      attribute: attribute != null ? attribute() : this.attribute,
      comparator: comparator != null ? comparator() : this.comparator,
      parameter: parameter != null ? parameter() : this.parameter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WhereClauseValue &&
        other.attribute == attribute &&
        other.comparator == comparator &&
        other.parameter == parameter;
  }

  @override
  int get hashCode {
    return attribute.hashCode ^ comparator.hashCode ^ parameter.hashCode;
  }

  @override
  String toString() {
    return 'WhereClauseValue(attribute: $attribute, comparator: $comparator, parameter: $parameter)';
  }
}
