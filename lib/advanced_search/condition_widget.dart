import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/advanced_search/dropdown_menu_form_field.dart';
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
    this.onChange,
    this.enabled = true,
  });

  final Condition condition;
  final void Function()? onRemove;
  final void Function(Condition condition)? onChange;
  final bool enabled;

  @override
  ConsumerState<ConditionWidget> createState() => _ConditionState();
}

class _ConditionState extends ConsumerState<ConditionWidget> {
  final hover = ValueNotifier(false);

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
      child: MouseRegion(
        onEnter: (event) => hover.value = true,
        onExit: (event) => hover.value = false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                final condition = Condition(
                  attribute: attribute?.id,
                  operator: attribute?.type.operators.firstOrNull,
                );
                widget.onChange?.call(condition);
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
                widget.onChange?.call(
                  widget.condition.copyWith(operator: () => operator),
                );
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
                widget.onChange?.call(
                  widget.condition.copyWith(parameter: () => value),
                );
              },
            ),
            if (widget.enabled)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: ListenableBuilder(
                  listenable: hover,
                  builder: (context, child) {
                    return Opacity(
                      opacity: hover.value ? 1 : 0,
                      child: IconButton(
                        tooltip: "Remove",
                        onPressed: widget.onRemove,
                        icon: Icon(
                          Symbols.remove_circle,
                          color: ColorScheme.of(context).onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
