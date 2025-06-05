import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:dynamische_materialdatenbank/search/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
