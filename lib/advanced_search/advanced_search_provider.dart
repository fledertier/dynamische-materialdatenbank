import 'package:dynamische_materialdatenbank/advanced_search/condition.dart';
import 'package:dynamische_materialdatenbank/advanced_search/query_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_type.dart';
import '../constants.dart';
import '../providers/attribute_provider.dart';

final queryProvider = NotifierProvider<QueryNotifier, MaterialQuery?>(
  QueryNotifier.new,
);

class QueryNotifier extends Notifier<MaterialQuery?> {
  @override
  MaterialQuery? build() {
    return null;
  }

  set query(MaterialQuery? query) {
    state = query;
  }

  set filterOptions(Map<String, dynamic> options) {
    ref.read(attributesStreamProvider).whenData((attributes) {
      final clauses = <Condition>[];

      for (final attribute in [
        Attributes.recyclable,
        Attributes.biodegradable,
        Attributes.biobased,
      ]) {
        final value = options[attribute];
        if (value == true) {
          clauses.add(
            Condition(
              attribute: attributes[attribute]!,
              parameter: value,
              comparator: Comparator.equals,
            ),
          );
        }
      }

      final manufacturer = options[Attributes.manufacturer];
      if (manufacturer is String && manufacturer.isNotEmpty) {
        clauses.add(
          Condition(
            attribute: attributes[Attributes.manufacturer]!,
            parameter: manufacturer,
            comparator: Comparator.equals,
          ),
        );
      }

      final weight = options[Attributes.weight];
      if (weight is double) {
        clauses.add(
          Condition(
            attribute: attributes[Attributes.weight]!,
            parameter: weight,
            comparator: Comparator.lessThan,
          ),
        );
      }

      state = MaterialQuery(conditions: clauses);
    });
  }
}

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
