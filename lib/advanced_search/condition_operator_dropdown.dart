import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionOperatorDropdown extends ConsumerWidget {
  const ConditionOperatorDropdown({
    super.key,
    this.enabled = true,
    this.initialOperator,
    this.attribute,
    this.onSelected,
  });

  final bool enabled;
  final Operator? initialOperator;
  final Attribute? attribute;
  final ValueChanged<Operator?>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operators = attribute?.type.operators ?? {};

    return DropdownMenuFormField(
      key: ValueKey(attribute),
      hintText: "Operator",
      initialSelection:
          initialOperator ?? attribute?.type.operators.firstOrNull,
      enabled: enabled && attribute != null,
      requestFocusOnTap: false,
      dropdownMenuEntries: [
        for (final operator in operators)
          DropdownMenuEntry(value: operator, label: operator.name),
      ],
      onSelected: onSelected,
      validator: (operator) {
        if (attribute != null && operator == null) {
          return "Please select an operator";
        }
        return null;
      },
    );
  }
}
