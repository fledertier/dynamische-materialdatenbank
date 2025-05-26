import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'attribute.dart';
import 'attribute_delete_dialog.dart';
import 'attribute_dialog.dart';
import 'attribute_form_state.dart';
import 'attribute_type.dart';
import 'attributes_list.dart';

class AttributeForm extends ConsumerStatefulWidget {
  const AttributeForm({
    super.key,
    required this.controller,
    required this.onSave,
  });

  final AttributeFormController controller;
  final void Function(Attribute attribute) onSave;

  @override
  ConsumerState<AttributeForm> createState() => AttributeFormState();
}

class AttributeFormState extends ConsumerState<AttributeForm> {
  final _form = GlobalKey<FormState>();
  late final _controller = widget.controller;
  late final _initialController = AttributeFormController(
    widget.controller.initialAttribute,
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              ListenableBuilder(
                listenable: _controller.nameEn,
                builder: (context, child) {
                  return TextFormField(
                    initialValue: _controller.nameDe.value,
                    decoration: InputDecoration(
                      labelText: 'Name (De)',
                      hintText: _controller.nameEn.value,
                    ),
                    onChanged: (value) {
                      _controller.nameDe.value = value;
                    },
                  );
                },
              ),
              ListenableBuilder(
                listenable: _controller.nameDe,
                builder: (context, child) {
                  return TextFormField(
                    initialValue: _controller.nameEn.value,
                    decoration: InputDecoration(
                      labelText: 'Name (En)',
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
              _controller.objectAttributes,
            ]),
            builder: (context, child) {
              late final typeField = DropdownMenuFormField<String>(
                initialSelection: _controller.type.value,
                label: Text('Type'),
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
                  _controller.type.value = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a type';
                  }
                  return null;
                },
              );
              late final listTypeDropdown = DropdownMenuFormField<String>(
                initialSelection: _controller.listType.value,
                label: Text('List type'),
                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: false,
                menuHeight: 300,
                dropdownMenuEntries: [
                  for (final value in AttributeType.values)
                    if (value != AttributeType.list)
                      DropdownMenuEntry(
                        value: value,
                        label: value,
                        leadingIcon: Icon(iconForAttributeType(value)),
                      ),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Please select a list type';
                  }
                  return null;
                },
                onSelected: (value) {
                  _controller.listType.value = value;
                },
              );
              late final unitDropdown = DropdownMenuFormField<UnitType>(
                initialSelection: _controller.unitType.value,
                label: Text('Unit'),
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
              late final objectAttributes = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8),
                  for (final attribute in _controller.objectAttributes.value)
                    AttributeListTile(
                      attribute,
                      onTap: () {
                        editAttribute(attribute);
                      },
                      trailing: IconButton(
                        icon: Icon(Symbols.remove_circle),
                        onPressed: () {
                          deleteAttribute(attribute);
                        },
                      ),
                    ),
                  SizedBox(height: 8),
                  OutlinedButton.icon(
                    style: IconButton.styleFrom(),
                    icon: Icon(Icons.add),
                    label: Text('Add attribute'),
                    onPressed: () {
                      addAttribute();
                    },
                  ),
                ],
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Expanded(child: typeField),
                      if (hasType(AttributeType.list))
                        Expanded(child: listTypeDropdown),
                      if (hasType(AttributeType.number))
                        Expanded(child: unitDropdown),
                    ],
                  ),
                  if (hasType(AttributeType.object)) objectAttributes,
                ],
              );
            },
          ),
          ListenableBuilder(
            listenable: Listenable.merge([
              _controller.type,
              _controller.listType,
            ]),
            builder: (context, child) {
              final requiredCheckbox = Row(
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
                  Text('Required'),
                ],
              );
              final multilineCheckbox = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListenableBuilder(
                    listenable: _controller.multiline,
                    builder: (context, child) {
                      return Checkbox(
                        value: _controller.multiline.value ?? false,
                        onChanged: (value) {
                          _controller.multiline.value = value;
                        },
                      );
                    },
                  ),
                  Text('Multiline'),
                ],
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  if (hasType(AttributeType.text)) multilineCheckbox,
                  requiredCheckbox,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> addAttribute() async {
    final attribute = await showNestedAttributeDialog(
      context: context,
      onSave: (attribute) async {
        _addAttribute(attribute);
        await save();
      },
    );
    if (attribute != null) {
      _addAttribute(attribute);
    }
  }

  void _addAttribute(Attribute objectAttribute) {
    _controller.objectAttributes.value = [
      ..._controller.objectAttributes.value,
      objectAttribute,
    ];
  }

  Future<void> editAttribute(Attribute attribute) async {
    final updatedAttribute = await showNestedAttributeDialog(
      context: context,
      initialAttribute: attribute,
      onSave: (updatedAttribute) async {
        _editAttribute(updatedAttribute);
        await save();
      },
    );
    if (updatedAttribute != null) {
      _editAttribute(updatedAttribute);
    }
  }

  void _editAttribute(Attribute updatedAttribute) {
    _controller.objectAttributes.value = [
      for (final objectAttribute in _controller.objectAttributes.value)
        objectAttribute.id == updatedAttribute.id
            ? updatedAttribute
            : objectAttribute,
    ];
  }

  Future<void> save() async {
    final attribute = await submit();
    if (attribute != null) {
      widget.onSave(attribute);
    }
  }

  void deleteAttribute(Attribute attribute) {
    _controller.objectAttributes.value = [
      for (final objectAttribute in _controller.objectAttributes.value)
        if (objectAttribute.id != attribute.id) objectAttribute,
    ];
  }

  bool hasType(String type) {
    return _controller.type.value == type ||
        _controller.type.value == AttributeType.list &&
            _controller.listType.value == type;
  }

  bool get hasChanges {
    return _controller != _initialController;
  }

  Future<Attribute?> submit() async {
    final attributesToDelete = _initialController.objectAttributes.value.where(
      (attribute) => _controller.objectAttributes.value.none(
        (objectAttribute) => objectAttribute.id == attribute.id,
      ),
    );
    final deletionConfirmed = _confirmAttributeDeletion(attributesToDelete);

    if (_form.currentState!.validate() && await deletionConfirmed) {
      final attribute = Attribute(
        id: _controller.id.value ?? generateId(),
        nameDe: _controller.nameDe.value,
        nameEn: _controller.nameEn.value,
        type: _createAttributeType(_controller.type.value!),
        required: _controller.required.value ?? false,
      );

      for (final attribute in attributesToDelete) {
        // todo: delete attribute
      }

      return attribute;
    }
    return null;
  }

  Future<bool> _confirmAttributeDeletion(Iterable<Attribute> attributes) async {
    final delete = await Future.wait(
      attributes.map(
        (attribute) => showAttributeDeleteDialog(context, attribute),
      ),
    );
    return delete.every((delete) => delete);
  }

  AttributeType _createAttributeType(String type) {
    return switch (type) {
      AttributeType.text => TextAttributeType(
        multiline: _controller.multiline.value ?? false,
      ),
      AttributeType.number => NumberAttributeType(
        unitType: _controller.unitType.value,
      ),
      AttributeType.boolean => BooleanAttributeType(),
      AttributeType.url => UrlAttributeType(),
      AttributeType.country => CountryAttributeType(),
      AttributeType.object => ObjectAttributeType(
        attributes: _controller.objectAttributes.value,
      ),
      AttributeType.list => ListAttributeType(
        type: _createAttributeType(_controller.listType.value!),
      ),
      _ => throw Exception('Invalid type ${_controller.type.value}'),
    };
  }

  @override
  void dispose() {
    _initialController.dispose();
    super.dispose();
  }
}
