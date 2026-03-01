import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_type.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/features/query/models/condition.dart';
import 'package:dynamische_materialdatenbank/features/query/models/condition_group.dart';
import 'package:dynamische_materialdatenbank/features/search/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = Provider((ref) {
  final search = ref.watch(searchProvider);

  if (search.isEmpty) {
    return null;
  }

  return ConditionGroup.or([
    Condition(
      attributePath: AttributePath(Attributes.name),
      operator: Operator.contains,
      parameter: TranslatableText.fromValue(search),
    ),
    Condition(
      attributePath: AttributePath(Attributes.description),
      operator: Operator.contains,
      parameter: TranslatableText.fromValue(search),
    ),
  ]);
});
