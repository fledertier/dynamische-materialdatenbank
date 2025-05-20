import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionAttributeDropdown extends ConsumerWidget {
  const ConditionAttributeDropdown({
    super.key,
    this.enabled = true,
    this.initialAttribute,
    this.onSelected,
  });

  final bool enabled;
  final Attribute? initialAttribute;
  final ValueChanged<Attribute?>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attributesById = ref.watch(attributesProvider).value ?? {};
    final attributes = attributesById.values.sortedBy(
      (attribute) => attribute.name,
    );

    return DropdownMenuFormField<Attribute>(
      hintText: "Attribute",
      enabled: enabled,
      enableFilter: true,
      width: 200,
      menuHeight: 500,
      initialSelection: initialAttribute,
      dropdownMenuEntries: [
        for (final attribute in attributes)
          DropdownMenuEntry(value: attribute, label: attribute.name),
      ],
      onSelected: onSelected,
      validator: (attribute) {
        if (attribute == null) {
          return "Please select an attribute";
        }
        return null;
      },
    );
  }
}
