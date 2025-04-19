import 'package:dynamische_materialdatenbank/advanced_search/condition.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_type.dart';
import '../types.dart';
import 'material_query.dart';

// idea: filter each attribute individually instead of the whole material
// idea: sort attributes by cost

final queryServiceProvider = Provider((ref) => QueryService());

class QueryService {
  List<Material> execute(MaterialQuery query, List<Material> materials) {
    return materials.where((material) {
      return query.conditions.every((clause) => matches(clause, material));
    }).toList();
  }

  bool matches(Condition clause, Material material) {
    final value = material[clause.attribute.id];
    if (value == null) {
      return false;
    }
    return switch (clause.comparator) {
      Comparator.equals => value == clause.parameter,
      Comparator.notEquals => value != clause.parameter,
      Comparator.greaterThan => value > clause.parameter,
      Comparator.lessThan => value < clause.parameter,
      Comparator.contains => value.toString().containsIgnoreCase(
        clause.parameter.toString(),
      ),
      Comparator.notContains =>
        !value.toString().containsIgnoreCase(clause.parameter.toString()),
    };
  }
}
