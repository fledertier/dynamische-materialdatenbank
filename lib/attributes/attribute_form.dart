import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/material.dart';

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
          spacing: 20,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
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
            DropdownButtonFormField<AttributeType>(
              value: _attribute.value["type"],
              decoration: InputDecoration(
                labelText: "Type",
                constraints: BoxConstraints(maxWidth: fieldWidth),
              ),
              style: TextTheme.of(context).bodyLarge,
              items: [
                for (final value in AttributeType.values)
                  DropdownMenuItem(
                    value: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(value.icon),
                        SizedBox(width: 8),
                        Text(value.name),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) {
                update('type', value);
                _type.text = value?.name ?? '';
              },
              validator: (value) {
                if (value == null) {
                  return "Please select a type";
                }
                return null;
              },
            ),
            ValueListenableBuilder(
              valueListenable: _type,
              builder: (context, value, child) {
                if (_attribute.value["type"] != AttributeType.number) {
                  return SizedBox();
                }
                return child!;
              },
              child: DropdownButtonFormField<UnitType>(
                value: _attribute.value["unitType"],
                decoration: InputDecoration(
                  labelText: "Unit type",
                  constraints: BoxConstraints(maxWidth: fieldWidth),
                ),
                style: TextTheme.of(context).bodyLarge,
                items: [
                  for (final value in UnitType.values)
                    DropdownMenuItem(value: value, child: Text(value.name)),
                ],
                onChanged: (value) {
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

  late final _attribute = ValueNotifier(widget.attribute);

  bool get hasChanged => _attribute.value != widget.attribute;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final attribute = Attribute(
        id: widget.attribute.id,
        nameDe: _attribute.value.nameDe,
        nameEn:
            _attribute.value.nameEn?.isNotEmpty ?? false
                ? _attribute.value.nameEn
                : null,
        type: widget.attribute.type,
        unitType: widget.attribute.unitType,
        required: _attribute.value.required == true ? true : null,
      );
      widget.onEditAttribute?.call(attribute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
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
            DropdownButtonFormField<AttributeType>(
              value: _attribute.value.type,
              decoration: InputDecoration(
                labelText: "Type",
                constraints: BoxConstraints(maxWidth: fieldWidth),
              ),
              style: theme.textTheme.bodyLarge,
              items: [
                for (final type in AttributeType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(type.icon, color: theme.disabledColor),
                        SizedBox(width: 8),
                        Text(type.name),
                      ],
                    ),
                  ),
              ],
              onChanged: null,
            ),
            if (_attribute.value.type == AttributeType.number)
              DropdownButtonFormField<UnitType>(
                value: _attribute.value.unitType,
                decoration: InputDecoration(
                  labelText: "Unit type",
                  constraints: BoxConstraints(maxWidth: fieldWidth),
                ),
                style: theme.textTheme.bodyLarge,
                items: [
                  for (final value in UnitType.values)
                    DropdownMenuItem(value: value, child: Text(value.name)),
                ],
                onChanged: null,
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
