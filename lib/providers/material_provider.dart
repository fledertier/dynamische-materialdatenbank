import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/material_service.dart';
import 'attribute_provider.dart';

final materialItemsStreamProvider = FutureProvider((ref) async {
  final names = await ref.watch(attributeStreamProvider("name").future);
  final materials = names.entries.map((entry) {
    return {"id": entry.key, "name": entry.value};
  });
  final query = ref.watch(searchProvider);
  return materials.where((material) {
    return material["name"].toLowerCase().contains(query.toLowerCase());
  }).toList();
});

final materialStreamProvider = StreamProvider.family((ref, String id) {
  return ref.read(materialServiceProvider).getMaterialStream(id);
});
