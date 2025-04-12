import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/filter_service.dart';
import '../services/material_service.dart';
import '../services/search_service.dart';
import 'attribute_provider.dart';
import 'filter_provider.dart';

final filteredMaterialItemsStreamProvider = FutureProvider((ref) async {
  final query = ref.watch(searchProvider);
  final filterState = ref.watch(filterProvider);
  final attributes = AttributesParameter({
    "name",
    if (query.isNotEmpty) "description",
    if (filterState.recyclable != null) "recyclable",
    if (filterState.biodegradable != null) "biodegradable",
    if (filterState.biobased != null) "biobased",
    if (filterState.manufacturer != null) "manufacturer",
    if (filterState.weight != null) "weight",
  });
  var materials = await ref.watch(materialsStreamProvider(attributes).future);
  materials = search(materials, query);
  materials = filter(materials, filterState);
  return materials;
});

final materialsStreamProvider = FutureProvider.family((
  ref,
  AttributesParameter parameter,
) async {
  final attributes = await ref.watch(
    attributesValuesStreamProvider(parameter).future,
  );
  return attributes.values.toList();
});

final materialStreamProvider = StreamProvider.family((ref, String id) {
  return ref.read(materialServiceProvider).getMaterialStream(id);
});
