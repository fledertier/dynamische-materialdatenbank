import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../services/filter_service.dart';
import '../services/material_service.dart';
import '../services/search_service.dart';
import 'attribute_provider.dart';
import 'filter_provider.dart';

final filteredMaterialItemsStreamProvider = FutureProvider((ref) async {
  final query = ref.watch(searchProvider);
  final filterOptions = ref.watch(filterProvider);
  final attributes = AttributesParameter({
    Attributes.name,
    if (query.isNotEmpty) Attributes.description,
    ...filterOptions.keys,
  });
  var materials = await ref.watch(materialsStreamProvider(attributes).future);
  materials = ref.read(searchServiceProvider).search(materials, query);
  materials = ref.read(filterServiceProvider).filter(materials, filterOptions);
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
