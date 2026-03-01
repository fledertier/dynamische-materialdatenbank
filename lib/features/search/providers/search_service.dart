import 'package:dynamische_materialdatenbank/features/attributes/models/attribute.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_type.dart';
import 'package:dynamische_materialdatenbank/features/attributes/providers/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/features/query/models/condition.dart';
import 'package:dynamische_materialdatenbank/features/query/models/condition_group.dart';
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
