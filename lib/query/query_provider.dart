import 'package:dynamische_materialdatenbank/advanced_search/condition.dart';
import 'package:dynamische_materialdatenbank/query/query_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../advanced_search/advanced_search_provider.dart';
import '../constants.dart';
import '../filter/filter_provider.dart';
import '../providers/attribute_provider.dart';
import '../search/search_query_provider.dart';

final queriedMaterialItemsProvider = FutureProvider.autoDispose((ref) async {
  final source = ref.watch(querySourceProvider);
  final query = switch (source) {
    QuerySource.searchAndFilter => ref.watch(searchAndFilterQueryProvider),
    QuerySource.advancedSearch => ref.watch(advancedSearchQueryProvider).query,
  };
  final parameter = AttributesParameter({Attributes.name, ...query.attributes});
  final materialsById = await ref.watch(
    attributesValuesStreamProvider(parameter).future,
  );
  return materialsById.values.where(query.matches).toList();
});

final searchAndFilterQueryProvider = Provider((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final filterQuery = ref.watch(filterQueryProvider);
  return ConditionGroup(
    type: ConditionGroupType.and,
    nodes: [searchQuery, filterQuery].nonNulls.toList(),
  );
});
