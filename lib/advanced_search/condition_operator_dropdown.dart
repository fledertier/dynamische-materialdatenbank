import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionOperatorDropdown extends ConsumerWidget {
  const ConditionOperatorDropdown({
    super.key,
    this.enabled = true,
    this.initialOperator,
    this.attributePath,
    this.onSelected,
  });

  final bool enabled;
  final Operator? initialOperator;
  final AttributePath? attributePath;
  final ValueChanged<Operator?>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(attributePath)).value;
    final operators = attribute?.type.operators ?? {};

    final selectedOperator = initialOperator ?? operators.firstOrNull;

    return DropdownMenuFormField(
      key: ValueKey(selectedOperator),
      hintText: 'Operator',
      initialSelection: selectedOperator,
      enabled: enabled && operators.isNotEmpty,
      requestFocusOnTap: false,
      dropdownMenuEntries: [
        for (final operator in operators)
          DropdownMenuEntry(value: operator, label: operator.name),
      ],
      onSelected: onSelected,
      validator: (operator) {
        if (attribute != null && operator == null) {
          return 'Please select an operator';
        }
        return null;
      },
    );
  }
}
