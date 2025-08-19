import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterQueryProvider = Provider((ref) {
  final options = ref.watch(filterOptionsProvider);

  if (options.isEmpty) {
    return null;
  }

  return ConditionGroup.and([
    for (final attributeId in [
      Attributes.recyclable,
      Attributes.biodegradable,
      Attributes.biobased,
    ])
      if (options[attributeId] != null)
        Condition(
          attributePath: AttributePath(attributeId),
          operator: Operator.equals,
          parameter: options[attributeId],
        ),
    if (options[Attributes.manufacturer] != null)
      Condition(
        attributePath: AttributePath.of([
          Attributes.manufacturer,
          Attributes.manufacturerName,
        ]),
        operator: Operator.equals,
        parameter: options[Attributes.manufacturer],
      ),

    if (options[Attributes.density]?.start != null)
      Condition(
        attributePath: AttributePath(Attributes.density),
        operator: Operator.greaterThan,
        parameter: UnitNumber(value: options[Attributes.density].start),
      ),
    if (options[Attributes.density]?.end != null)
      Condition(
        attributePath: AttributePath(Attributes.density),
        operator: Operator.lessThan,
        parameter: UnitNumber(value: options[Attributes.density].end),
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
