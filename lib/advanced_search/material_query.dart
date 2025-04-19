import 'condition.dart';

class MaterialQuery {
  final List<Condition> conditions;

  const MaterialQuery({required this.conditions});

  Set<String> attributeIds() {
    return conditions.map((clause) => clause.attribute.id).toSet();
  }

  bool containsAttribute(String attributeId) {
    return conditions.any((clause) => clause.attribute.id == attributeId);
  }
}
