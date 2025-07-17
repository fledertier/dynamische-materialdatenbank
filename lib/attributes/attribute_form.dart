import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_dialog.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_form_controller.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_list.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/units.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:dynamische_materialdatenbank/widgets/hover_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

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
              _controller.listAttribute,
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a type';
                  }
                  return null;
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
                    DropdownMenuEntry(value: value, label: value.id),
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
                  Column(
                    spacing: 6,
                    children: [
                      for (final attribute
                          in _controller.objectAttributes.value)
                        HoverBuilder(
                          builder: (context, hovered, child) {
                            return AttributeListTile(
                              attribute,
                              onTap: () {
                                editAttribute(attribute, _editObjectAttribute);
                              },
                              filled: true,
                              trailing: MenuAnchor(
                                builder: (context, controller, child) {
                                  return IconButton(
                                    onPressed: controller.toggle,
                                    icon: Visibility.maintain(
                                      visible: hovered || controller.isOpen,
                                      child: Icon(Icons.more_vert),
                                    ),
                                  );
                                },
                                menuChildren: [
                                  MenuItemButton(
                                    leadingIcon: Icon(Symbols.content_copy),
                                    requestFocusOnHover: false,
                                    onPressed: () {
                                      _copyAttributeId(attribute);
                                    },
                                    child: Text('Copy id'),
                                  ),
                                  MenuItemButton(
                                    leadingIcon: Icon(Symbols.remove),
                                    requestFocusOnHover: false,
                                    onPressed: () {
                                      _deleteObjectAttribute(attribute);
                                    },
                                    child: Text('Remove'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  OutlinedButton.icon(
                    style: IconButton.styleFrom(),
                    icon: Icon(Icons.add),
                    label: Text('Add attribute'),
                    onPressed: () {
                      addAttribute(_addObjectAttribute);
                    },
                  ),
                ],
              );
              late final listAttribute = FormField(
                initialValue: _controller.listAttribute.value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return 'Please select an attribute';
                  }
                  return null;
                },
                builder: (field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      errorText: field.errorText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (field.value != null) ...[
                          SizedBox(height: 8),
                          HoverBuilder(
                            builder: (context, hovered, child) {
                              return AttributeListTile(
                                field.value!,
                                onTap: () {
                                  editAttribute(field.value!, (attribute) {
                                    _controller.listAttribute.value = attribute;
                                    field.didChange(attribute);
                                  });
                                },
                                filled: true,
                                trailing: MenuAnchor(
                                  builder: (context, controller, child) {
                                    return IconButton(
                                      onPressed: controller.toggle,
                                      icon: Visibility.maintain(
                                        visible: hovered || controller.isOpen,
                                        child: Icon(Icons.more_vert),
                                      ),
                                    );
                                  },
                                  menuChildren: [
                                    MenuItemButton(
                                      leadingIcon: Icon(Symbols.content_copy),
                                      requestFocusOnHover: false,
                                      onPressed: () {
                                        _copyAttributeId(field.value!);
                                      },
                                      child: Text('Copy id'),
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Symbols.remove),
                                      requestFocusOnHover: false,
                                      onPressed: () {
                                        _controller.listAttribute.value = null;
                                        field.didChange(null);
                                      },
                                      child: Text('Remove'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ] else ...[
                          SizedBox(height: 16),
                          OutlinedButton(
                            style:
                                field.hasError
                                    ? OutlinedButton.styleFrom(
                                      foregroundColor:
                                          ColorScheme.of(context).error,
                                      side: BorderSide(
                                        color: ColorScheme.of(context).error,
                                      ),
                                    )
                                    : null,
                            child: Text('Select attribute'),
                            onPressed: () {
                              addAttribute((attribute) {
                                _controller.listAttribute.value = attribute;
                                field.didChange(attribute);
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Expanded(child: typeField),
                      if (isType(AttributeType.number))
                        Expanded(child: unitDropdown),
                    ],
                  ),
                  if (isType(AttributeType.object)) objectAttributes,
                  if (isType(AttributeType.list)) listAttribute,
                ],
              );
            },
          ),
          ListenableBuilder(
            listenable: _controller.type,
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
              final translatableCheckbox = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListenableBuilder(
                    listenable: _controller.translatable,
                    builder: (context, child) {
                      return Checkbox(
                        value: _controller.translatable.value ?? false,
                        onChanged: (value) {
                          _controller.translatable.value = value;
                        },
                      );
                    },
                  ),
                  Text('Translatable'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  if (isType(AttributeType.text)) translatableCheckbox,
                  if (isType(AttributeType.text)) multilineCheckbox,
                  requiredCheckbox,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  bool isType(String type) => _controller.type.value == type;

  Future<void> addAttribute(void Function(Attribute) add) async {
    final attribute = await showNestedAttributeDialog(
      context: context,
      onSave: (attribute) async {
        add(attribute);
        await save();
      },
    );
    if (attribute != null) {
      add(attribute);
    }
  }

  Future<void> editAttribute(
    Attribute attribute,
    void Function(Attribute) edit,
  ) async {
    final updatedAttribute = await showNestedAttributeDialog(
      context: context,
      initialAttribute: attribute,
      onSave: (updatedAttribute) async {
        edit(updatedAttribute);
        await save();
      },
    );
    if (updatedAttribute != null) {
      edit(updatedAttribute);
    }
  }

  void _addObjectAttribute(Attribute objectAttribute) {
    _controller.objectAttributes.value = [
      ..._controller.objectAttributes.value,
      objectAttribute,
    ];
  }

  void _editObjectAttribute(Attribute updatedAttribute) {
    _controller.objectAttributes.value = [
      for (final objectAttribute in _controller.objectAttributes.value)
        objectAttribute.id == updatedAttribute.id
            ? updatedAttribute
            : objectAttribute,
    ];
  }

  void _deleteObjectAttribute(Attribute attribute) {
    _controller.objectAttributes.value = [
      for (final objectAttribute in _controller.objectAttributes.value)
        if (objectAttribute.id != attribute.id) objectAttribute,
    ];
  }

  void _copyAttributeId(Attribute attribute) {
    Clipboard.setData(ClipboardData(text: attribute.id));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Id copied to clipboard')));
  }

  bool get hasChanges {
    return _controller != _initialController;
  }

  Future<void> save() async {
    final attribute = await submit();
    if (attribute != null) {
      widget.onSave(attribute);
    }
  }

  Future<Attribute?> submit() async {
    if (!_form.currentState!.validate()) {
      return null;
    }
    return Attribute(
      id: _controller.id.value ?? generateId(),
      nameDe: _controller.nameDe.value,
      nameEn: _controller.nameEn.value,
      type: _createAttributeType(_controller.type.value!),
      required: _controller.required.value ?? false,
    );
  }

  AttributeType _createAttributeType(String type) {
    return switch (type) {
      AttributeType.text => TextAttributeType(
        translatable: _controller.translatable.value ?? false,
        multiline: _controller.multiline.value ?? false,
      ),
      AttributeType.number => NumberAttributeType(
        unitType: _controller.unitType.value,
      ),
      AttributeType.boolean => BooleanAttributeType(),
      AttributeType.url => UrlAttributeType(),
      AttributeType.object => ObjectAttributeType(
        attributes: _controller.objectAttributes.value,
      ),
      AttributeType.list => ListAttributeType(
        attribute: _controller.listAttribute.value!,
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
