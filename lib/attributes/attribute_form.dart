import 'package:dynamische_materialdatenbank/attributes/attribute_form_state.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/dropdown_menu_form_field.dart';
import 'attribute.dart';
import 'attribute_provider.dart';
import 'attribute_service.dart';
import 'attribute_type.dart';

class AttributeForm extends ConsumerStatefulWidget {
  const AttributeForm({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final AttributeFormController? controller;
  final void Function(Attribute attribute) onSubmit;

  @override
  ConsumerState<AttributeForm> createState() => AttributeFormState();
}

class AttributeFormState extends ConsumerState<AttributeForm> {
  final _form = GlobalKey<FormState>();
  late final _controller = widget.controller ?? AttributeFormController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              TextFormField(
                initialValue: _controller.nameDe.value,
                decoration: InputDecoration(labelText: "Name (De)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
                onChanged: (value) {
                  _controller.nameDe.value = value;
                },
              ),
              ListenableBuilder(
                listenable: _controller.nameDe,
                builder: (context, child) {
                  return TextFormField(
                    initialValue: _controller.nameEn.value,
                    decoration: InputDecoration(
                      labelText: "Name (En)",
                      hintText: _controller.nameDe.value,
                    ),
                    onChanged: (value) {
                      _controller.nameEn.value = value;
                    },
                  );
                },
              ),
            ],
          ),
          ListenableBuilder(
            listenable: Listenable.merge([
              _controller.type,
              _controller.listType,
            ]),
            builder: (context, child) {
              late final typeField = DropdownMenuFormField<String>(
                initialSelection: _controller.type.value,
                label: Text("Type"),
                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: false,
                menuHeight: 300,
                dropdownMenuEntries: [
                  for (final value in AttributeType.values)
                    DropdownMenuEntry(
                      value: value,
                      label: value,
                      leadingIcon: Icon(iconForAttributeType(value)),
                    ),
                ],
                enabled: _controller.initialAttribute == null,
                onSelected: (value) {
                  _controller.type.value = value;
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a type";
                  }
                  return null;
                },
              );
              late final listTypeDropdown = DropdownMenuFormField<String>(
                initialSelection: _controller.listType.value,
                label: Text("List type"),
                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: false,
                menuHeight: 300,
                dropdownMenuEntries: [
                  for (final value in AttributeType.values)
                    DropdownMenuEntry(
                      value: value,
                      label: value,
                      leadingIcon: Icon(iconForAttributeType(value)),
                    ),
                ],
                onSelected: (value) {
                  _controller.listType.value = value;
                },
              );
              late final unitDropdown = DropdownMenuFormField<UnitType>(
                initialSelection: _controller.unitType.value,
                label: Text("Unit"),
                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: false,
                menuHeight: 300,
                dropdownMenuEntries: [
                  for (final value in UnitTypes.values)
                    DropdownMenuEntry(value: value, label: value.name),
                ],
                onSelected: (value) {
                  _controller.unitType.value = value;
                },
              );
              return Row(
                spacing: 16,
                children: [
                  Expanded(child: typeField),
                  if (isList) Expanded(child: listTypeDropdown),
                  if (isNumber) Expanded(child: unitDropdown),
                ],
              );
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListenableBuilder(
                listenable: _controller.required,
                builder: (context, child) {
                  return Checkbox(
                    value: _controller.required.value ?? false,
                    onChanged: (value) {
                      _controller.required.value = value;
                    },
                  );
                },
              ),
              Text("Required"),
            ],
          ),
        ],
      ),
    );
  }

  bool get isList => _controller.type.value == AttributeType.list;

  bool get isNumber {
    return _controller.type.value == AttributeType.number ||
        isList && _controller.listType.value == AttributeType.number;
  }

  Future<void> submit() async {
    if (_form.currentState!.validate()) {
      final attribute = Attribute(
        id: _controller.id.value ?? await _createId(),
        nameDe: _controller.nameDe.value!,
        nameEn: _controller.nameEn.value,
        type: switch (_controller.type.value!) {
          AttributeType.number => NumberAttributeType(
            unitType: _controller.unitType.value,
          ),
          AttributeType.list => ListAttributeType(
            type: switch (_controller.listType.value!) {
              AttributeType.number => NumberAttributeType(
                unitType: _controller.unitType.value,
              ),
              AttributeType.text => TextAttributeType(),
              AttributeType.textarea => TextareaAttributeType(),
              AttributeType.boolean => BooleanAttributeType(),
              AttributeType.object => ObjectAttributeType(),
              AttributeType.proportions => ProportionsAttributeType(),
              AttributeType.countedTags => CountedTagsAttributeType(),
              AttributeType.countries => CountriesAttributeType(),
              _ =>
                throw Exception(
                  'Invalid list type ${_controller.listType.value}',
                ),
            },
          ),
          AttributeType.text => TextAttributeType(),
          AttributeType.textarea => TextareaAttributeType(),
          AttributeType.boolean => BooleanAttributeType(),
          AttributeType.object => ObjectAttributeType(),
          AttributeType.proportions => ProportionsAttributeType(),
          AttributeType.countedTags => CountedTagsAttributeType(),
          AttributeType.countries => CountriesAttributeType(),
          _ => throw Exception('Invalid type ${_controller.type.value}'),
        },
        required: _controller.required.value ?? false,
      );
      widget.onSubmit(attribute);
    }
  }

  Future<String> _createId() async {
    final name = _controller.nameEn.value ?? _controller.nameDe.value!;
    final attributes = await ref.read(attributesProvider.future);
    return ref
        .read(attributeServiceProvider)
        .nearestAvailableAttributeId(name.toLowerCase(), attributes);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
