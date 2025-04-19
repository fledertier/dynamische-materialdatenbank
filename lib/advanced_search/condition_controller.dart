import 'package:dynamische_materialdatenbank/advanced_search/condition.dart';
import 'package:flutter/cupertino.dart';

import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';

class ConditionController extends ValueNotifier<ConditionValue> {
  ConditionController([Condition? value])
    : super(
        ConditionValue(
          attribute: value?.attribute,
          comparator: value?.comparator,
          parameter: value?.parameter,
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

  Condition toCondition() {
    return Condition(
      attribute: attribute!,
      comparator: comparator!,
      parameter: parameter!,
    );
  }
}

class ConditionValue {
  final Attribute? attribute;
  final Comparator? comparator;
  final Object? parameter;

  const ConditionValue({this.attribute, this.comparator, this.parameter});

  ConditionValue copyWith({
    Attribute? Function()? attribute,
    Comparator? Function()? comparator,
    Object? Function()? parameter,
  }) {
    return ConditionValue(
      attribute: attribute != null ? attribute() : this.attribute,
      comparator: comparator != null ? comparator() : this.comparator,
      parameter: parameter != null ? parameter() : this.parameter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConditionValue &&
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
    return 'ConditionValue(attribute: $attribute, comparator: $comparator, parameter: $parameter)';
  }
}
