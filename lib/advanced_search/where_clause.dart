import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';

class WhereClause {
  final Attribute attribute;
  final Comparator comparator;
  final Object parameter;

  const WhereClause({
    required this.attribute,
    required this.comparator,
    required this.parameter,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WhereClause &&
        other.attribute == attribute &&
        other.comparator == comparator &&
        other.parameter == parameter;
  }

  @override
  int get hashCode {
    return attribute.hashCode ^ comparator.hashCode ^ parameter.hashCode;
  }
}
