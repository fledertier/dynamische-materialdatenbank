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

  late final _id = ValueNotifier(widget.initialAttribute?.id);
  late final _nameDe = ValueNotifier(widget.initialAttribute?.nameDe);
  late final _nameEn = ValueNotifier(widget.initialAttribute?.nameEn);
  late final _type = ValueNotifier(widget.initialAttribute?.type);
  late final _unitType = ValueNotifier(widget.initialAttribute?.unitType);
  late final _required = ValueNotifier(
    widget.initialAttribute?.required ?? false,
  );

  late final _attribute = Listenable.merge([
    _nameDe,
    _nameEn,
    _type,
    _unitType,
    _required,
  ]);

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
                  initialValue: _nameDe.value,
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
                    _nameDe.value = value;
                  },
                ),
                ListenableBuilder(
                  listenable: _nameDe,
                  builder: (context, child) {
                    return TextFormField(
                      initialValue: _nameEn.value,
                      decoration: InputDecoration(
                        labelText: "Name (En)",
                        hintText: _nameDe.value,
                        constraints: BoxConstraints(maxWidth: fieldWidth),
                      ),
                      onChanged: (value) {
                        _nameEn.value = value;
                      },
                    );
                  },
                ),
              ],
            ),
            ListenableBuilder(
              listenable: _type,
              child: DropdownMenuFormField<AttributeType>(
                initialSelection: _type.value,
                label: Text("Type"),
                width: fieldWidth,
                requestFocusOnTap: false,
                dropdownMenuEntries: [
                  for (final value
                      in widget.initialAttribute?.type.exchangeableTypes ??
                          AttributeType.values)
                    DropdownMenuEntry(
                      value: value,
                      label: value.name,
                      leadingIcon: Icon(value.icon),
                    ),
                ],
                enabled:
                    widget.initialAttribute?.type.hasExchangeableTypes ?? true,
                onSelected: (value) {
                  _type.value = value;
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
                  initialSelection: _unitType.value,
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
                    _unitType.value = value;
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
                  listenable: _required,
                  builder: (context, child) {
                    return Checkbox(
                      value: _required.value,
                      onChanged: (value) {
                        _required.value = value!;
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
                    onPressed: hasChanges ? _submitForm : null,
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

  bool get hasUnit => _type.value == AttributeType.number;

  bool get hasChanges {
    return _nameDe.value != widget.initialAttribute?.nameDe ||
        _nameEn.value != widget.initialAttribute?.nameEn ||
        _type.value != widget.initialAttribute?.type ||
        _unitType.value != widget.initialAttribute?.unitType ||
        _required.value != widget.initialAttribute?.required;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final attribute = Attribute(
        id: _id.value ?? await _createId(),
        nameDe: _nameDe.value!,
        nameEn: _nameEn.value,
        type: _type.value!,
        unitType: hasUnit ? _unitType.value : null,
        required: _required.value,
      );
      widget.onSubmit(attribute);
    }
  }

  Future<String> _createId() async {
    final name = _nameEn.value ?? _nameDe.value!;
    final attributes = await ref.read(attributesProvider.future);
    return ref
        .read(attributeServiceProvider)
        .nearestAvailableAttributeId(name.toLowerCase(), attributes);
  }
}
