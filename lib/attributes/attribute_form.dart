import 'package:flutter/material.dart';

import 'attribute.dart';
import 'attribute_type.dart';

const double fieldWidth = 280;

class CreateAttributeForm extends StatefulWidget {
  const CreateAttributeForm({super.key, this.onCreateAttribute});

  final void Function(CreateAttribute attribute)? onCreateAttribute;

  @override
  State<CreateAttributeForm> createState() => _CreateAttributeFormState();
}

class _CreateAttributeFormState extends State<CreateAttributeForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameDe = TextEditingController();
  final _nameEn = TextEditingController();
  AttributeType? _type;
  bool _required = false;

  @override
  void dispose() {
    _nameDe.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final attribute = CreateAttribute(
        name: _nameDe.text,
        type: _type!,
        required: _required,
      );
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
                ),
                ListenableBuilder(
                  listenable: _nameDe,
                  builder: (context, child) {
                    return TextFormField(
                      controller: _nameEn,
                      decoration: InputDecoration(
                        labelText: "Name (En)",
                        hintText: _nameDe.text,
                        constraints: BoxConstraints(maxWidth: fieldWidth),
                      ),
                    );
                  },
                ),
              ],
            ),
            DropdownButtonFormField<AttributeType>(
              value: _type,
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
                setState(() {
                  _type = value;
                });
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
                Checkbox(
                  value: _required,
                  onChanged: (value) {
                    setState(() {
                      _required = value ?? false;
                    });
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
  final void Function(UpdateAttribute attribute)? onEditAttribute;

  @override
  State<EditAttributeForm> createState() => _EditAttributeFormState();
}

class _EditAttributeFormState extends State<EditAttributeForm> {
  final _formKey = GlobalKey<FormState>();

  // todo: insert initial values
  final _nameDe = TextEditingController();
  final _nameEn = TextEditingController();
  AttributeType? _type;
  bool _required = false;

  @override
  void dispose() {
    _nameDe.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final attribute = UpdateAttribute(
        id: widget.attribute.id,
        name: _nameDe.text,
        required: _required,
      );
      widget.onEditAttribute?.call(attribute);
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
                ),
                ListenableBuilder(
                  listenable: _nameDe,
                  builder: (context, child) {
                    return TextFormField(
                      controller: _nameEn,
                      decoration: InputDecoration(
                        labelText: "Name (En)",
                        hintText: _nameDe.text,
                        constraints: BoxConstraints(maxWidth: fieldWidth),
                      ),
                    );
                  },
                ),
              ],
            ),
            DropdownButtonFormField<AttributeType>(
              value: _type,
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
                setState(() {
                  _type = value;
                });
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
                Checkbox(
                  value: _required,
                  onChanged: (value) {
                    setState(() {
                      _required = value ?? false;
                    });
                  },
                ),
                Text("Required"),
              ],
            ),
            // todo: disable when no changes
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: FilledButton(onPressed: _submitForm, child: Text("Edit")),
            ),
          ],
        ),
      ),
    );
  }
}
