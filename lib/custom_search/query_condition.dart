import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute.dart';
import '../attributes/attribute_type.dart';
import '../providers/attribute_provider.dart';
import 'fields.dart';

class WhereClause extends ConsumerStatefulWidget {
  const WhereClause({super.key, this.controller});

  final WhereClauseController? controller;

  @override
  ConsumerState<WhereClause> createState() => _WhereClauseState();
}

class _WhereClauseState extends ConsumerState<WhereClause> {
  late final controller = widget.controller ?? WhereClauseController();

  @override
  Widget build(BuildContext context) {
    final attributes = ref.watch(attributesProvider).value?.values ?? [];

    return Theme(
      data: Theme.of(context).copyWith(
        dropdownMenuTheme: DropdownMenuTheme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            constraints: const BoxConstraints(maxHeight: 48),
            border: OutlineInputBorder(),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          constraints: const BoxConstraints(maxHeight: 48, maxWidth: 200),
          border: OutlineInputBorder(),
        ),
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final allowedOperations =
              controller.attribute?.type.allowedOperations ?? {};

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text("Where"),
              ),
              DropdownMenu(
                hintText: "Attribute",
                width: 200,
                dropdownMenuEntries:
                    attributes.map((attribute) {
                      return DropdownMenuEntry(
                        value: attribute,
                        label: attribute.name,
                      );
                    }).toList(),
                onSelected: (value) {
                  controller.value = WhereClauseValue(attribute: value);
                },
              ),
              DropdownMenu(
                key: ValueKey(controller.attribute),
                initialSelection: allowedOperations.firstOrNull,
                hintText: "Operation",
                enabled: controller.attribute != null,
                dropdownMenuEntries:
                    allowedOperations.map((operation) {
                      return DropdownMenuEntry(
                        value: operation,
                        label: operation.name,
                      );
                    }).toList(),
                onSelected: (value) {
                  controller.operation = value;
                },
              ),
              buildParameterField(),
            ],
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
          onChanged: (value) {
            controller.parameter = value;
          },
        );
      case AttributeType.number:
        return NumberField(
          onChanged: (value) {
            controller.parameter = value;
          },
        );
      case AttributeType.boolean:
        return BooleanField(
          onChanged: (value) {
            controller.parameter = value;
          },
        );
      default:
        return EmptyField();
    }
  }
}

class WhereClauseController extends ValueNotifier<WhereClauseValue> {
  WhereClauseController()
    : super(
        const WhereClauseValue(
          attribute: null,
          operation: null,
          parameter: null,
        ),
      );

  Attribute? get attribute => value.attribute;

  set attribute(Attribute? attribute) {
    value = value.copyWith(attribute: () => attribute);
  }

  Operation? get operation => value.operation;

  set operation(Operation? operation) {
    value = value.copyWith(operation: () => operation);
  }

  Object? get parameter => value.parameter;

  set parameter(Object? parameter) {
    value = value.copyWith(parameter: () => parameter);
  }
}

class WhereClauseValue {
  final Attribute? attribute;
  final Operation? operation;
  final Object? parameter;

  const WhereClauseValue({this.attribute, this.operation, this.parameter});

  WhereClauseValue copyWith({
    Attribute? Function()? attribute,
    Operation? Function()? operation,
    Object? Function()? parameter,
  }) {
    return WhereClauseValue(
      attribute: attribute != null ? attribute() : this.attribute,
      operation: operation != null ? operation() : this.operation,
      parameter: parameter != null ? parameter() : this.parameter,
    );
  }
}
