import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionAttributeDropdown extends ConsumerWidget {
  const ConditionAttributeDropdown({
    super.key,
    this.enabled = true,
    this.initialAttribute,
    required this.onSelected,
    this.attributeEntries,
    this.depth = 0,
  });

  final bool enabled;
  final String? initialAttribute;
  final ValueChanged<String?> onSelected;
  final List<Attribute>? attributeEntries;
  final int depth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attributesById = ref
        .watch(attributesProvider)
        .value ?? {};
    final attributes = attributesById.values.sortedBy(
          (attribute) => attribute.name,
    );
    final attributeId = extractId(initialAttribute, depth);
    final attribute = ref.watch(attributeProvider(attributeId));

    return Row(
      children: [
        DropdownMenuFormField<Attribute>(
          hintText: "Attribute",
          enabled: enabled,
          enableFilter: true,
          width: 200,
          menuHeight: 500,
          initialSelection: attribute,
          dropdownMenuEntries: [
            for (final attribute in attributeEntries ?? attributes)
              DropdownMenuEntry(value: attribute, label: attribute.name),
          ],
          onSelected: (attribute) {
            onSelected(attribute?.id);
          },
          validator: (attribute) {
            if (attribute == null) {
              return "Please select an attribute";
            }
            return null;
          },
        ),
        if (attribute?.type case ObjectAttributeType(:final attributes))
          ConditionAttributeDropdown(
            enabled: enabled,
            initialAttribute: initialAttribute,
            attributeEntries: attributes,
            onSelected: (subAttribute) {
              onSelected([attribute?.id, subAttribute].join('.'));
            },
            depth: depth + 1,
          ),
      ],
    );
  }

  String? extractId(String? attribute, int depth) {
    final subAttributes = attribute?.split('.') ?? [];
    if (depth >= subAttributes.length) {
      return null;
    }
    return subAttributes.take(depth + 1).join('.');
  }
}
