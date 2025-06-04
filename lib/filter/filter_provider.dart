import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterQueryProvider = Provider((ref) {
  final options = ref.watch(filterOptionsProvider);

  if (options.isEmpty) {
    return null;
  }

  return ConditionGroup.and([
    for (final attribute in [
      Attributes.recyclable,
      Attributes.biodegradable,
      Attributes.biobased,
    ])
      if (options[attribute] == true)
        Condition(
          attribute: attribute,
          operator: Operator.equals,
          parameter: options[attribute],
        ),
    if (options[Attributes.manufacturer] != null)
      Condition(
        attribute: [
          Attributes.manufacturer,
          Attributes.manufacturerName,
        ].join('.'),
        operator: Operator.equals,
        parameter: options[Attributes.manufacturer],
      ),

    if (options[Attributes.density] != null)
      Condition(
        attribute: Attributes.density,
        operator: Operator.lessThan,
        parameter: options[Attributes.density],
      ),
  ]);
});

final filterOptionsProvider = NotifierProvider(FilterOptionsNotifier.new);

class FilterOptionsNotifier extends Notifier<Json> {
  @override
  Json build() => {};

  void updateWith(Json options) {
    state = {...state, ...options}..removeWhere((key, value) => value == null);
  }

  void reset() {
    ref.invalidateSelf();
  }
}
