import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'material_service.dart';

final materialItemsStreamProvider = Provider((ref) {
  final names = ref.watch(attributeStreamProvider("name")).value ?? {};
  return names.entries.map((entry) {
    return {"id": entry.key, "name": entry.value};
  }).toList();
});

final attributeStreamProvider = StreamProvider.family((ref, String attribute) {
  return ref.read(materialServiceProvider).getAttributeStream(attribute);
});

final attributeProvider = FutureProvider.family((ref, String attribute) {
  return ref.read(materialServiceProvider).getAttribute(attribute);
});
