import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/advanced_search/dropdown_menu_form_field.dart';
import 'package:dynamische_materialdatenbank/hover_builder.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../providers/attribute_provider.dart';
import 'condition.dart';
import 'fields.dart';

class ConditionWidget extends ConsumerStatefulWidget {
  const ConditionWidget({
    super.key,
    required this.condition,
    this.onRemove,
    this.enabled = true,
  });

  final Condition condition;
  final void Function()? onRemove;
  final bool enabled;

  @override
  ConsumerState<ConditionWidget> createState() => _ConditionWidgetState();
}

class _ConditionWidgetState extends ConsumerState<ConditionWidget> {
  @override
  Widget build(BuildContext context) {
    final attributes =
        ref.watch(attributesProvider).value?.values.toList() ?? [];
    final attribute = attributes.firstWhereOrNull(
      (attribute) => attribute.id == widget.condition.attribute,
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
              enabled: widget.enabled,
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
                setState(() {
                  widget.condition.attribute = attribute?.id;
                  widget.condition.operator =
                      attribute?.type.operators.firstOrNull;
                  widget.condition.parameter = null;
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
              key: ValueKey(widget.condition.attribute),
              hintText: "Operator",
              initialSelection: widget.condition.operator,
              enabled: widget.enabled && widget.condition.attribute != null,
              dropdownMenuEntries:
                  operators.map((operation) {
                    return DropdownMenuEntry(
                      value: operation,
                      label: operation.name,
                    );
                  }).toList(),
              onSelected: (operator) {
                setState(() {
                  widget.condition.operator = operator;
                });
              },
              validator: (operator) {
                if (widget.condition.attribute != null && operator == null) {
                  return "Please select an operator";
                }
                return null;
              },
            ),
            ConditionParameterField(
              enabled: widget.enabled,
              type: attribute?.type,
              value: widget.condition.parameter,
              onChanged: (value) {
                setState(() {
                  widget.condition.parameter = value;
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
              if (widget.enabled)
                Visibility.maintain(
                  visible: hovered,
                  child: IconButton(
                    tooltip: "Remove",
                    onPressed: widget.onRemove,
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
