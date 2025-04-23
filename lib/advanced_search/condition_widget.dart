import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:dynamische_materialdatenbank/widgets/hover_builder.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../providers/attribute_provider.dart';
import '../query/condition.dart';
import 'parameter_fields.dart';

class ConditionWidget extends ConsumerWidget {
  const ConditionWidget({
    super.key,
    required this.condition,
    this.onChanged,
    this.onRemove,
    this.enabled = true,
  });

  final Condition condition;
  final void Function()? onChanged;
  final void Function()? onRemove;
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
                update(() {
                  condition.attribute = attribute?.id;
                  condition.operator = attribute?.type.operators.firstOrNull;
                  condition.parameter = null;
                });
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
                update(() {
                  condition.operator = operator;
                });
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
                update(() {
                  condition.parameter = value;
                });
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

  void update(void Function() update) {
    update();
    onChanged?.call();
  }
}
