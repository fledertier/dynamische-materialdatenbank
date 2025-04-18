import 'package:dynamische_materialdatenbank/advanced_search/query_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/attribute_provider.dart';

final queryProvider = StateProvider<MaterialQuery?>((ref) => null);

final queriedMaterialItemsProvider = FutureProvider.autoDispose<List<Material>>(
  (ref) async {
    final query = ref.watch(queryProvider);
    final parameter = AttributesParameter({
      Attributes.name,
      ...?query?.attributeIds(),
    });
    final materialsById = await ref.read(
      attributesValuesStreamProvider(parameter).future,
    );
    final materials = materialsById.values.toList();
    if (query == null) {
      return materials;
    }
    return ref.read(queryServiceProvider).execute(query, materials);
  },
);
