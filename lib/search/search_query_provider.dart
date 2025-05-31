import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_type.dart';
import '../constants.dart';
import '../query/condition.dart';
import '../query/condition_group.dart';
import 'search_provider.dart';

final searchQueryProvider = Provider((ref) {
  final search = ref.watch(searchProvider);

  if (search.isEmpty) {
    return null;
  }

  return ConditionGroup.or([
    Condition(
      attribute: Attributes.name,
      operator: Operator.contains,
      parameter: search,
    ),
    Condition(
      attribute: Attributes.description,
      operator: Operator.contains,
      parameter: search,
    ),
  ]);
});
