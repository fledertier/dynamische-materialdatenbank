import 'package:dynamische_materialdatenbank/advanced_search/advanced_search_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/filter/filter_provider.dart';
import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:dynamische_materialdatenbank/search/search_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'condition_group.dart';
import 'query_source_provider.dart';

final queriedMaterialsProvider = FutureProvider.autoDispose((ref) async {
  final source = ref.watch(querySourceProvider);
  final query = switch (source) {
    QuerySource.searchAndFilter => ref.watch(searchAndFilterQueryProvider),
    QuerySource.advancedSearch => ref.watch(advancedSearchQueryProvider).query,
  };
  final attributes = AttributesArgument({
    Attributes.name,
    Attributes.image,
    ...query.attributes,
  });
  final materials = await ref.watch(materialsProvider(attributes).future);
  final attributesById = await ref.watch(attributesProvider.future);
  return materials
      .where((material) => query.matches(material, attributesById))
      .toList();
});

final searchAndFilterQueryProvider = Provider((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final filterQuery = ref.watch(filterQueryProvider);
  return ConditionGroup(
    type: ConditionGroupType.and,
    nodes: [searchQuery, filterQuery].nonNulls.toList(),
  );
});
