import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/material.dart';

import '../custom_search/dropdown_menu_form_field.dart';
import 'attribute.dart';
import 'attribute_type.dart';

const double fieldWidth = 280;

class CreateAttributeForm extends StatefulWidget {
  const CreateAttributeForm({super.key, this.onCreateAttribute});

  final void Function(Map<String, dynamic> attribute)? onCreateAttribute;

  @override
  State<CreateAttributeForm> createState() => _CreateAttributeFormState();
}

class _CreateAttributeFormState extends State<CreateAttributeForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameDe = TextEditingController();
  final _type = TextEditingController();

  final _attribute = ValueNotifier<Map<String, dynamic>>({});

  @override
  void dispose() {
    _nameDe.dispose();
    _type.dispose();
    super.dispose();
  }

  void update(String key, dynamic value) {
    _attribute.value = {..._attribute.value, key: value};
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final attribute = {
        'nameDe': _attribute.value["nameDe"]!,
        if (_attribute.value["nameEn"]?.isNotEmpty ?? false)
          'nameEn': _attribute.value["nameEn"],
        'type': _attribute.value["type"]!.toJson(),
        if (_attribute.value["type"] == AttributeType.number &&
            _attribute.value["unitType"] != null)
          'unitType': (_attribute.value["unitType"]! as UnitType).name,
        if (_attribute.value["required"] == true) 'required': true,
      };
      widget.onCreateAttribute?.call(attribute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 24,
              children: [
                TextFormField(
                  controller: _nameDe,
                  decoration: InputDecoration(
                    labelText: "Name (De)",
                    constraints: BoxConstraints(maxWidth: fieldWidth),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    update('nameDe', value);
                  },
                ),
                ListenableBuilder(
                  listenable: _nameDe,
                  builder: (context, child) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: "Name (En)",
                        hintText: _nameDe.text,
                        constraints: BoxConstraints(maxWidth: fieldWidth),
                      ),
                      onChanged: (value) {
                        update('nameEn', value);
                      },
                    );
                  },
                ),
              ],
            ),
            DropdownMenuFormField<AttributeType>(
              initialSelection: _attribute.value["type"],
              width: fieldWidth,
              label: Text("Type"),
              dropdownMenuEntries: [
                for (final value in AttributeType.values)
                  DropdownMenuEntry(
                    value: value,
                    label: value.name,
                    leadingIcon: Icon(value.icon),
                  ),
              ],
              onSelected: (value) {
                update('type', value);
              },
              controller: _type,
              validator: (value) {
                if (value == null) {
                  return "Please select a type";
                }
                return null;
              },
            ),
            ListenableBuilder(
              listenable: _type,
              builder: (context, child) {
                if (_attribute.value["type"] != AttributeType.number) {
                  return SizedBox();
                }
                return child!;
              },
              child: DropdownMenuFormField<UnitType>(
                initialSelection: _attribute.value["unitType"],
                width: fieldWidth,
                label: Text("Unit type"),
                dropdownMenuEntries: [
                  for (final value in UnitType.values)
                    DropdownMenuEntry(value: value, label: value.name),
                ],
                onSelected: (value) {
                  update('unitType', value);
                },
              ),
            ),
            Row(
              children: [
                ListenableBuilder(
                  listenable: _attribute,
                  builder: (context, child) {
                    return Checkbox(
                      value: _attribute.value["required"] ?? false,
                      onChanged: (value) {
                        update('required', value);
                      },
                    );
                  },
                ),
                Text("Required"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: FilledButton(
                onPressed: _submitForm,
                child: Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditAttributeForm extends StatefulWidget {
  const EditAttributeForm({
    super.key,
    required this.attribute,
    this.onEditAttribute,
  });

  final Attribute attribute;
  final void Function(Attribute attribute)? onEditAttribute;

  @override
  State<EditAttributeForm> createState() => _EditAttributeFormState();
}

class _EditAttributeFormState extends State<EditAttributeForm> {
  final _formKey = GlobalKey<FormState>();

  final _type = TextEditingController();

  late var _savedAttribute = widget.attribute;
  late final _attribute = ValueNotifier(widget.attribute);

  bool get hasChanged => _attribute.value != _savedAttribute;

  @override
  void dispose() {
    _type.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final attribute = Attribute(
        id: widget.attribute.id,
        nameDe: _attribute.value.nameDe,
        nameEn:
            _attribute.value.nameEn?.isNotEmpty ?? false
                ? _attribute.value.nameEn
                : null,
        type: _attribute.value.type,
        unitType: _attribute.value.unitType,
        required: _attribute.value.required == true ? true : null,
      );
      widget.onEditAttribute?.call(attribute);
      setState(() {
        _savedAttribute = attribute;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 24,
              children: [
                TextFormField(
                  initialValue: widget.attribute.name,
                  decoration: InputDecoration(
                    labelText: "Name (De)",
                    constraints: BoxConstraints(maxWidth: fieldWidth),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _attribute.value = _attribute.value.copyWith(nameDe: value);
                  },
                ),
                ListenableBuilder(
                  listenable: _attribute,
                  builder: (context, child) {
                    return TextFormField(
                      initialValue: widget.attribute.nameEn,
                      decoration: InputDecoration(
                        labelText: "Name (En)",
                        hintText: _attribute.value.name,
                        constraints: BoxConstraints(maxWidth: fieldWidth),
                      ),
                      onChanged: (value) {
                        _attribute.value = _attribute.value.copyWith(
                          nameEn: value,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            DropdownMenuFormField<AttributeType>(
              initialSelection: _attribute.value.type,
              controller: _type,
              label: Text("Type"),
              width: fieldWidth,
              dropdownMenuEntries: [
                for (final value in _attribute.value.type.exchangeableTypes)
                  DropdownMenuEntry(
                    value: value,
                    label: value.name,
                    leadingIcon: Icon(value.icon),
                  ),
              ],
              enabled: _attribute.value.type.hasExchangeableTypes,
              onSelected: (value) {
                _attribute.value = _attribute.value.copyWith(type: value);
              },
            ),
            ListenableBuilder(
              listenable: _type,
              builder: (context, child) {
                if (_attribute.value.type != AttributeType.number) {
                  return SizedBox();
                }
                return child!;
              },
              child: DropdownMenuFormField<UnitType>(
                initialSelection: _attribute.value.unitType,
                label: Text("Unit type"),
                width: fieldWidth,
                dropdownMenuEntries: [
                  for (final value in UnitType.values)
                    DropdownMenuEntry(value: value, label: value.name),
                ],
                onSelected: (value) {
                  _attribute.value = _attribute.value.copyWith(unitType: value);
                },
              ),
            ),
            Row(
              children: [
                ListenableBuilder(
                  listenable: _attribute,
                  builder: (context, child) {
                    return Checkbox(
                      value: _attribute.value.required ?? false,
                      onChanged: (value) {
                        _attribute.value = _attribute.value.copyWith(
                          required: value ?? false,
                        );
                      },
                    );
                  },
                ),
                Text("Required"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListenableBuilder(
                listenable: _attribute,
                builder: (context, child) {
                  return FilledButton(
                    onPressed: hasChanged ? _submitForm : null,
                    child: Text("Save"),
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
