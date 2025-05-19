import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_type.dart';
import '../constants.dart';
import '../query/condition.dart';
import '../query/condition_group.dart';

final filterQueryProvider = Provider((ref) {
  final options = ref.watch(filterOptionsProvider);

  if (options.isEmpty) {
    return null;
  }

  return ConditionGroup(
    type: ConditionGroupType.and,
    nodes: [
      for (final attribute in [
        Attributes.recyclable,
        Attributes.biodegradable,
        Attributes.biobased,
      ])
        if (options[attribute] == true)
          Condition(
            attribute: [attribute],
            operator: Operator.equals,
            parameter: options[attribute],
          ),
      if (options[Attributes.manufacturer] is String)
        Condition(
          attribute: [Attributes.manufacturer],
          operator: Operator.equals,
          parameter: options[Attributes.manufacturer],
        ),

      if (options[Attributes.weight] is double)
        Condition(
          attribute: [Attributes.weight],
          operator: Operator.lessThan,
          parameter: options[Attributes.weight],
        ),
    ],
  );
});

final filterOptionsProvider = NotifierProvider(FilterOptionsNotifier.new);

class FilterOptionsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {};

  void updateWith(Map<String, dynamic> options) {
    state = {...state, ...options}..removeWhere((key, value) => value == null);
  }

  void reset() {
    ref.invalidateSelf();
  }
}
