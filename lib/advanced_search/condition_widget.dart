import 'package:dynamische_materialdatenbank/advanced_search/condition_attribute_dropdown.dart';
import 'package:dynamische_materialdatenbank/advanced_search/condition_operator_dropdown.dart';
import 'package:dynamische_materialdatenbank/advanced_search/condition_parameter_field.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/widgets/hover_builder.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

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
            ConditionAttributeDropdown(
              enabled: enabled,
              initialAttributePath: condition.attributePath,
              onSelected: (attributeId) async {
                final attribute = await ref.read(
                  attributeProvider(attributeId).future,
                );
                update(() {
                  condition.attributePath = attributeId;
                  condition.operator = attribute?.type.operators.firstOrNull;
                  condition.parameter = null;
                });
              },
            ),
            ConditionOperatorDropdown(
              enabled: enabled,
              initialOperator: condition.operator,
              attributePath: condition.attributePath,
              onSelected: (operator) {
                update(() {
                  condition.operator = operator;
                });
              },
            ),
            ConditionParameterField(
              enabled: enabled,
              value: condition.parameter,
              attributePath: condition.attributePath,
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
                    tooltip: 'Remove',
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
