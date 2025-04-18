import 'package:dynamische_materialdatenbank/advanced_search/where_clause.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_type.dart';

// idea: filter each attribute individually instead of the whole material
// idea: sort attributes by cost

final queryServiceProvider = Provider((ref) => QueryService());

class QueryService {
  List<Material> execute(MaterialQuery query, List<Material> materials) {
    return materials.where((material) {
      return query.whereClauses.every((clause) => matches(clause, material));
    }).toList();
  }

  bool matches(WhereClause clause, Material material) {
    final value = material[clause.attribute.id];
    if (value == null) {
      return false;
    }
    switch (clause.comparator) {
      case Comparator.equals:
        return value == clause.parameter;
      case Comparator.notEquals:
        return value != clause.parameter;
      case Comparator.greaterThan:
        return value > clause.parameter;
      case Comparator.lessThan:
        return value < clause.parameter;
      case Comparator.contains:
        return value.toString().contains(clause.parameter.toString());
      case Comparator.notContains:
        return !value.toString().contains(clause.parameter.toString());
    }
  }
}

typedef Material = Map<String, dynamic>;

class MaterialQuery {
  final List<WhereClause> whereClauses;

  const MaterialQuery({required this.whereClauses});

  Set<String> attributeIds() {
    return whereClauses.map((clause) => clause.attribute.id).toSet();
  }
}
