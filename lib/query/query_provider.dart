import 'package:dynamische_materialdatenbank/advanced_search/advanced_search_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/filter/filter_provider.dart';
import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:dynamische_materialdatenbank/search/search_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../header/sort.dart';
import '../utils/attribute_utils.dart';
import 'condition_group.dart';
import 'query_source_provider.dart';

final queriedMaterialsProvider = FutureProvider.autoDispose((ref) async {
  final source = ref.watch(querySourceProvider);
  final query = switch (source) {
    QuerySource.searchAndFilter => ref.watch(searchAndFilterQueryProvider),
    QuerySource.advancedSearch => ref.watch(advancedSearchQueryProvider).query,
  };
  final sortAttribute = ref.watch(sortAttributeProvider);
  final attributes = AttributesArgument({
    Attributes.name,
    Attributes.image,
    ...query.attributes,
    if (sortAttribute != null) sortAttribute,
  });
  final materials = await ref.watch(materialsProvider(attributes).future);
  final attributesById = await ref.watch(attributesProvider.future);
  final matching =
      materials
          .where((material) => query.matches(material, attributesById))
          .toList();
  if (sortAttribute != null) {
    matching.sort((a, b) {
      final value =
          getAttributeValue(a, attributesById, sortAttribute) as Comparable;
      final other =
          getAttributeValue(b, attributesById, sortAttribute) as Comparable;
      return value.compareTo(other);
    });
    final sortDirection = ref.watch(sortDirectionProvider);
    if (sortDirection == SortDirection.descending) {
      return matching.reversed.toList();
    }
    return matching;
  }
  return matching;
});

final searchAndFilterQueryProvider = Provider((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final filterQuery = ref.watch(filterQueryProvider);
  return ConditionGroup.and([searchQuery, filterQuery].nonNulls.toList());
});
