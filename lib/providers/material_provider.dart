import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/material_service.dart';
import 'attribute_provider.dart';

final materialItemsStreamProvider = FutureProvider((ref) async {
  final names = await ref.watch(attributeStreamProvider("name").future);
  return names.entries.map((entry) {
    return {"id": entry.key, "name": entry.value};
  }).toList();
});

final materialStreamProvider = StreamProvider.family((ref, String id) {
  return ref.read(materialServiceProvider).getMaterialStream(id);
});
