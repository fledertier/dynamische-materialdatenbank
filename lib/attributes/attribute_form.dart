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

  final _attribute = ValueNotifier<Map<String, dynamic>>({});

  @override
  void dispose() {
    _nameDe.dispose();
    super.dispose();
  }

  void update(String key, dynamic value) {
    _attribute.value = {..._attribute.value, key: value};
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final attribute = {
        'nameDe': _attribute.value["nameDe"]!,
        'nameEn': _attribute.value["nameEn"],
        'type': _attribute.value["type"]!.toJson(),
        'required': _attribute.value["required"] ?? false,
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
              style: Theme.of(context).textTheme.bodyLarge,
              items:
                  AttributeType.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(value.icon()),
                              SizedBox(width: 8),
                              Text(value.name),
                            ],
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                update('type', value);
              },
              validator: (value) {
                if (value == null) {
                  return "Please select a type";
                }
                return null;
              },
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
      widget.onEditAttribute?.call(_attribute.value);
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
              style: Theme.of(context).textTheme.bodyLarge,
              items:
                  AttributeType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(type.icon()),
                          SizedBox(width: 8),
                          Text(type.name),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: null,
            ),
            Row(
              children: [
                ListenableBuilder(
                  listenable: _attribute,
                  builder: (context, child) {
                    return Checkbox(
                      value: _attribute.value.required,
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
