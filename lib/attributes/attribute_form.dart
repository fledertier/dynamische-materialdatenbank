import 'package:dynamische_materialdatenbank/attributes/attribute_form_state.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/dropdown_menu_form_field.dart';
import 'attribute.dart';
import 'attribute_provider.dart';
import 'attribute_service.dart';
import 'attribute_type.dart';

const double fieldWidth = 280;

class AttributeForm extends ConsumerStatefulWidget {
  const AttributeForm({
    super.key,
    required this.initialAttribute,
    required this.onSubmit,
  });

  final Attribute? initialAttribute;
  final void Function(Attribute attribute) onSubmit;

  @override
  ConsumerState<AttributeForm> createState() => _AttributeFormState();
}

class _AttributeFormState extends ConsumerState<AttributeForm> {
  final _formKey = GlobalKey<FormState>();

  late final _attribute = AttributeFormState(widget.initialAttribute);

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
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
                  initialValue: _attribute.nameDe.value,
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
                    _attribute.nameDe.value = value;
                  },
                ),
                ListenableBuilder(
                  listenable: _attribute.nameDe,
                  builder: (context, child) {
                    return TextFormField(
                      initialValue: _attribute.nameEn.value,
                      decoration: InputDecoration(
                        labelText: "Name (En)",
                        hintText: _attribute.nameDe.value,
                        constraints: BoxConstraints(maxWidth: fieldWidth),
                      ),
                      onChanged: (value) {
                        _attribute.nameEn.value = value;
                      },
                    );
                  },
                ),
              ],
            ),
            ListenableBuilder(
              listenable: _attribute.type,
              child: DropdownMenuFormField<AttributeType>(
                initialSelection: _attribute.type.value,
                label: Text("Type"),
                width: fieldWidth,
                requestFocusOnTap: false,
                dropdownMenuEntries: [
                  for (final value in AttributeType.values)
                    DropdownMenuEntry(
                      value: value,
                      label: value.name,
                      leadingIcon: Icon(value.icon),
                    ),
                ],
                enabled: widget.initialAttribute == null,
                onSelected: (value) {
                  _attribute.type.value = value;
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a type";
                  }
                  return null;
                },
              ),
              builder: (context, typeField) {
                final unitDropdown = DropdownMenuFormField<UnitType>(
                  initialSelection: _attribute.unitType.value,
                  label: Text("Unit"),
                  width: fieldWidth,
                  menuHeight: 500,
                  enableFilter: true,
                  enableSearch: false,
                  dropdownMenuEntries: [
                    for (final value in UnitTypes.values)
                      DropdownMenuEntry(value: value, label: value.name),
                  ],
                  onSelected: (value) {
                    _attribute.unitType.value = value;
                  },
                );
                return Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  children: [typeField!, if (hasUnit) unitDropdown],
                );
              },
            ),
            Row(
              children: [
                ListenableBuilder(
                  listenable: _attribute.required,
                  builder: (context, child) {
                    return Checkbox(
                      value: _attribute.required.value ?? false,
                      onChanged: (value) {
                        _attribute.required.value = value;
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
                    onPressed: _attribute.hasChanges ? _submitForm : null,
                    child: Text(
                      widget.initialAttribute != null ? "Save" : "Create",
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

  bool get hasUnit => _attribute.type.value == AttributeType.number;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final attribute = Attribute(
        id: _attribute.id.value ?? await _createId(),
        nameDe: _attribute.nameDe.value!,
        nameEn: _attribute.nameEn.value,
        type: _attribute.type.value!,
        unitType: hasUnit ? _attribute.unitType.value : null,
        required: _attribute.required.value ?? false,
      );
      widget.onSubmit(attribute);
    }
  }

  Future<String> _createId() async {
    final name = _attribute.nameEn.value ?? _attribute.nameDe.value!;
    final attributes = await ref.read(attributesProvider.future);
    return ref
        .read(attributeServiceProvider)
        .nearestAvailableAttributeId(name.toLowerCase(), attributes);
  }

  @override
  void dispose() {
    _attribute.dispose();
    super.dispose();
  }
}
