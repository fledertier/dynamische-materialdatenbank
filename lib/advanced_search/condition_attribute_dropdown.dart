import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionAttributeDropdown extends ConsumerWidget {
  const ConditionAttributeDropdown({
    super.key,
    this.enabled = true,
    this.initialAttributePath,
    required this.onSelected,
    this.attributeEntries,
    this.depth = 0,
  });

  final bool enabled;
  final AttributePath? initialAttributePath;
  final ValueChanged<AttributePath> onSelected;
  final List<Attribute>? attributeEntries;
  final int depth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attributesById = ref.watch(attributesProvider).value ?? {};
    final attributes = attributesById.values.sortedBy(
      (attribute) => attribute.name ?? '',
    );
    final attributePath = subPath(initialAttributePath, depth);
    final attribute = ref.watch(attributeProvider(attributePath)).value;

    return Row(
      children: [
        DropdownMenuFormField<Attribute>(
          hintText: 'Attribute',
          enabled: enabled,
          enableFilter: true,
          width: 200,
          menuHeight: 500,
          initialSelection: attribute,
          dropdownMenuEntries: [
            for (final attribute in attributeEntries ?? attributes)
              DropdownMenuEntry(
                value: attribute,
                label: attribute.name ?? 'Unnamed',
              ),
          ],
          onSelected: (attribute) {
            onSelected(AttributePath(attribute!.id));
          },
          validator: (attribute) {
            if (attribute == null) {
              return 'Please select an attribute';
            }
            return null;
          },
        ),
        if (attribute?.type case ObjectAttributeType(:final attributes))
          ConditionAttributeDropdown(
            enabled: enabled,
            initialAttributePath: initialAttributePath,
            attributeEntries: attributes,
            onSelected: (subPath) {
              onSelected(AttributePath.of([attribute!.id, ...subPath.ids]));
            },
            depth: depth + 1,
          )
        else if (attribute?.type case ListAttributeType(
          attribute: final listAttribute,
        ))
          ConditionAttributeDropdown(
            enabled: enabled,
            initialAttributePath: initialAttributePath,
            attributeEntries: listAttribute.childAttributes,
            onSelected: (subPath) {
              onSelected(
                AttributePath.of([
                  attribute!.id,
                  listAttribute.id,
                  ...subPath.ids,
                ]),
              );
            },
            depth: depth + 2,
          ),
      ],
    );
  }

  AttributePath? subPath(AttributePath? path, int depth) {
    if (path == null || depth >= path.ids.length) {
      return null;
    }
    return AttributePath.of(path.ids.take(depth + 1).toList());
  }
}
