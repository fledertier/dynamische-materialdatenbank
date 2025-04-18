import 'package:dynamische_materialdatenbank/advanced_search/where_clause_controller.dart';
import 'package:dynamische_materialdatenbank/custom_search/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../attributes/attribute_type.dart';
import '../providers/attribute_provider.dart';
import 'fields.dart';

class WhereClauseWidget extends ConsumerStatefulWidget {
  const WhereClauseWidget({super.key, this.controller, this.onRemove});

  final WhereClauseController? controller;
  final void Function()? onRemove;

  @override
  ConsumerState<WhereClauseWidget> createState() => _WhereClauseState();
}

class _WhereClauseState extends ConsumerState<WhereClauseWidget> {
  late final controller = widget.controller ?? WhereClauseController();
  final hover = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final attributes = ref.watch(attributesProvider).value?.values ?? [];

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
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final operations = controller.attribute?.type.operators ?? {};

          return MouseRegion(
            onEnter: (event) => hover.value = true,
            onExit: (event) => hover.value = false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  DropdownMenuFormField(
                    hintText: "Attribute",
                    width: 200,
                    dropdownMenuEntries:
                        attributes.map((attribute) {
                          return DropdownMenuEntry(
                            value: attribute,
                            label: attribute.name,
                          );
                        }).toList(),
                    onSelected: (attribute) {
                      controller.value = WhereClauseValue(
                        attribute: attribute,
                        comparator: attribute?.type.operators.firstOrNull,
                      );
                    },
                    validator: (attribute) {
                      if (attribute == null) {
                        return "Please select an attribute";
                      }
                      return null;
                    },
                  ),
                  DropdownMenuFormField(
                    key: ValueKey(controller.attribute),
                    initialSelection: operations.firstOrNull,
                    hintText: "Operator",
                    enabled: controller.attribute != null,
                    dropdownMenuEntries:
                        operations.map((operation) {
                          return DropdownMenuEntry(
                            value: operation,
                            label: operation.name,
                          );
                        }).toList(),
                    onSelected: (operator) {
                      controller.comparator = operator;
                    },
                    validator: (operator) {
                      if (controller.attribute != null && operator == null) {
                        return "Please select an operator";
                      }
                      return null;
                    },
                  ),
                  buildParameterField(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: ListenableBuilder(
                      listenable: hover,
                      builder: (context, child) {
                        return Opacity(
                          opacity: hover.value ? 1 : 0,
                          child: IconButton(
                            onPressed: () => widget.onRemove?.call(),
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
        },
      ),
    );
  }

  Widget buildParameterField() {
    final attributeType = controller.attribute?.type;

    switch (attributeType) {
      case AttributeType.text || AttributeType.textarea:
        return TextField(
          required: true,
          onChanged: (value) {
            controller.parameter = value;
          },
        );
      case AttributeType.number:
        return NumberField(
          required: true,
          onChanged: (value) {
            controller.parameter = value;
          },
        );
      case AttributeType.boolean:
        return BooleanField(
          // initialValue: true,
          required: true,
          onChanged: (value) {
            controller.parameter = value;
          },
        );
      default:
        return EmptyField();
    }
  }
}
