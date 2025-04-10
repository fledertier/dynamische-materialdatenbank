import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../header/material_search.dart';
import '../services/material_service.dart';
import 'attribute_provider.dart';

final filteredMaterialItemsStreamProvider = FutureProvider((ref) async {
  final materials = await ref.watch(materialItemsStreamProvider.future);
  final query = ref.watch(searchProvider);
  return search(materials, query);
});

final materialItemsStreamProvider = FutureProvider((ref) async {
  final parameter = AttributesParameter({"name", "description"});
  return await ref.watch(materialsStreamProvider(parameter).future);
});

final materialsStreamProvider = FutureProvider.family((
  ref,
  AttributesParameter parameter,
) async {
  final attributes = await ref.watch(
    attributesStreamProvider(parameter).future,
  );
  return attributes.values.toList();
});

final materialStreamProvider = StreamProvider.family((ref, String id) {
  return ref.read(materialServiceProvider).getMaterialStream(id);
});
