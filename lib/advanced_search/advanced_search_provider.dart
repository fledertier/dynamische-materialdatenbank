import 'package:dynamische_materialdatenbank/advanced_search/condition.dart';
import 'package:dynamische_materialdatenbank/advanced_search/query_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_type.dart';
import '../constants.dart';
import '../providers/attribute_provider.dart';
import '../types.dart';
import 'material_query.dart';

final queryProvider = NotifierProvider<QueryNotifier, MaterialQuery>(
  QueryNotifier.new,
);

class QueryNotifier extends Notifier<MaterialQuery> {
  @override
  MaterialQuery build() {
    return MaterialQuery();
  }

  set query(MaterialQuery query) {
    state = query;
  }

  set customConditions(List<Condition> conditions) {
    state = state.copyWith(customConditions: conditions);
  }

  set filterOptions(Map<String, dynamic> options) {
    ref.read(attributesStreamProvider).whenData((attributes) {
      final conditions = <Condition>[];

      for (final attribute in [
        Attributes.recyclable,
        Attributes.biodegradable,
        Attributes.biobased,
      ]) {
        final value = options[attribute];
        if (value == true) {
          conditions.add(
            Condition(
              attribute: attribute,
              operator: Operator.equals,
              parameter: value,
            ),
          );
        }
      }

      final manufacturer = options[Attributes.manufacturer];
      if (manufacturer is String && manufacturer.isNotEmpty) {
        conditions.add(
          Condition(
            attribute: Attributes.manufacturer,
            operator: Operator.equals,
            parameter: manufacturer,
          ),
        );
      }

      final weight = options[Attributes.weight];
      if (weight is double) {
        conditions.add(
          Condition(
            attribute: Attributes.weight,
            operator: Operator.lessThan,
            parameter: weight,
          ),
        );
      }

      filterConditions = conditions;
    });
  }

  set filterConditions(List<Condition> conditions) {
    state = state.copyWith(filterConditions: conditions);
  }

  set searchQuery(String searchQuery) {
    ref.read(attributesStreamProvider).whenData((attributes) {
      late final conditions = [
        Condition(
          attribute: Attributes.name,
          operator: Operator.contains,
          parameter: searchQuery,
        ),
        Condition(
          attribute: Attributes.description,
          operator: Operator.contains,
          parameter: searchQuery,
        ),
      ];

      searchConditions = searchQuery.isNotEmpty ? conditions : [];
    });
  }

  set searchConditions(List<Condition> conditions) {
    state = state.copyWith(searchConditions: conditions);
  }
}

final queriedMaterialItemsProvider = FutureProvider.autoDispose<List<Material>>(
  (ref) async {
    final query = ref.watch(queryProvider);
    final parameter = AttributesParameter({
      Attributes.name,
      ...query.conditions
          .where((condition) => condition.isValid)
          .map((condition) => condition.attribute!),
    });
    final materialsById = await ref.read(
      attributesValuesStreamProvider(parameter).future,
    );
    final materials = materialsById.values.toList();
    return ref.read(queryServiceProvider).execute(query, materials);
  },
);
