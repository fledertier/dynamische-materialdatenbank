import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchServiceProvider = FutureProvider.autoDispose((ref) async {
  final attributesById = await ref.watch(attributesProvider.future);
  return SearchService(attributesById);
});

class SearchService {
  SearchService(this.attributesById);

  final Map<String, Attribute> attributesById;

  List<Json> search(
    List<Json> materials,
    Set<String> attributes,
    String search,
  ) {
    final query = ConditionGroup.or([
      for (final attribute in attributes)
        Condition(
          attribute: attribute,
          operator: Operator.contains,
          parameter: search,
        ),
    ]);
    return materials
        .where((material) => query.matches(material, attributesById))
        .toList();
  }
}
