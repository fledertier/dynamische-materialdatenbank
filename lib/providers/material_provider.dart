import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute_provider.dart';

final materialItemsStreamProvider = FutureProvider((ref) async {
  final names = await ref.watch(attributeStreamProvider("name").future);
  return names.entries.map((entry) {
    return {"id": entry.key, "name": entry.value};
  }).toList();
});
