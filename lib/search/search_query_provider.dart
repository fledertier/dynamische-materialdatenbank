import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:dynamische_materialdatenbank/search/search_provider.dart';
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
      parameter: TranslatableText(valueDe: search),
    ),
    Condition(
      attributePath: AttributePath(Attributes.description),
      operator: Operator.contains,
      parameter: TranslatableText(valueDe: search),
    ),
  ]);
});
