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
      return query.conditions.every(
        (condition) => matches(condition, material),
      );
    }).toList();
  }

  bool matches(Condition condition, Material material) {
    final value = material[condition.attribute.id];
    if (value == null) {
      return false;
    }
    return switch (condition.comparator) {
      Comparator.equals => value == condition.parameter,
      Comparator.notEquals => value != condition.parameter,
      Comparator.greaterThan => value > condition.parameter,
      Comparator.lessThan => value < condition.parameter,
      Comparator.contains => value.toString().containsIgnoreCase(
        condition.parameter.toString(),
      ),
      Comparator.notContains =>
        !value.toString().containsIgnoreCase(condition.parameter.toString()),
    };
  }
}
