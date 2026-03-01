import 'package:dynamische_materialdatenbank/features/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/features/query/condition.dart';
import 'package:dynamische_materialdatenbank/features/query/condition_group.dart';
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
    Set<AttributePath> attributes,
    String search,
  ) {
    final query = ConditionGroup.or([
      for (final attributePath in attributes)
        Condition(
          attributePath: attributePath,
          operator: Operator.contains,
          parameter: TranslatableText.fromValue(search),
        ),
    ]);
    return materials
        .where((material) => query.matches(material, attributesById))
        .toList();
  }
}
