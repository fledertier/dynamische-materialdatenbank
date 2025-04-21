import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/advanced_search/dropdown_menu_form_field.dart';
import 'package:dynamische_materialdatenbank/hover_builder.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../providers/attribute_provider.dart';
import 'condition.dart';
import 'fields.dart';

class ConditionWidget extends ConsumerWidget {
  const ConditionWidget({
    super.key,
    required this.condition,
    this.onRemove,
    this.onChange,
    this.enabled = true,
  });

  final Condition condition;
  final void Function()? onRemove;
  final void Function(Condition condition)? onChange;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attributes =
        ref.watch(attributesProvider).value?.values.toList() ?? [];
    final attribute = attributes.firstWhereOrNull(
      (attribute) => attribute.id == condition.attribute,
    );
    final operators = attribute?.type.operators ?? {};
    return Theme(
      data: Theme.of(context).copyWith(
        dropdownMenuTheme: DropdownMenuTheme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          constraints: const BoxConstraints(maxWidth: 200),
          border: OutlineInputBorder(),
        ),
      ),
      child: HoverBuilder(
        child: Row(
          spacing: 8,
          children: [
            DropdownMenuFormField(
              hintText: "Attribute",
              enabled: enabled,
              width: 200,
              initialSelection: attribute,
              dropdownMenuEntries:
                  attributes.map((attribute) {
                    return DropdownMenuEntry(
                      value: attribute,
                      label: attribute.name,
                    );
                  }).toList(),
              onSelected: (attribute) {
                final condition = Condition(
                  attribute: attribute?.id,
                  operator: attribute?.type.operators.firstOrNull,
                );
                onChange?.call(condition);
              },
              validator: (attribute) {
                if (attribute == null) {
                  return "Please select an attribute";
                }
                return null;
              },
            ),
            DropdownMenuFormField(
              key: ValueKey(condition.attribute),
              hintText: "Operator",
              initialSelection: condition.operator,
              enabled: enabled && condition.attribute != null,
              dropdownMenuEntries:
                  operators.map((operation) {
                    return DropdownMenuEntry(
                      value: operation,
                      label: operation.name,
                    );
                  }).toList(),
              onSelected: (operator) {
                onChange?.call(condition.copyWith(operator: () => operator));
              },
              validator: (operator) {
                if (condition.attribute != null && operator == null) {
                  return "Please select an operator";
                }
                return null;
              },
            ),
            ConditionParameterField(
              enabled: enabled,
              type: attribute?.type,
              value: condition.parameter,
              onChanged: (value) {
                onChange?.call(condition.copyWith(parameter: () => value));
              },
            ),
          ],
        ),
        builder: (context, hovered, child) {
          return Row(
            spacing: 8,
            children: [
              child!,
              if (enabled)
                Visibility.maintain(
                  visible: hovered,
                  child: IconButton(
                    tooltip: "Remove",
                    onPressed: onRemove,
                    icon: Icon(
                      Symbols.remove_circle,
                      color: ColorScheme.of(context).onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
