import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/material.dart';

import '../widgets/dropdown_menu_form_field.dart';
import 'attribute.dart';
import 'attribute_type.dart';

const double fieldWidth = 280;

class AttributeForm extends StatefulWidget {
  const AttributeForm({
    super.key,
    required this.initialAttribute,
    required this.onSubmit,
  });

  final AttributeData initialAttribute;
  final void Function(AttributeData attribute) onSubmit;

  @override
  State<AttributeForm> createState() => _AttributeFormState();
}

class _AttributeFormState extends State<AttributeForm> {
  final _formKey = GlobalKey<FormState>();

  late final _attribute = ValueNotifier(widget.initialAttribute);

  bool get hasChanged => _attribute.value != widget.initialAttribute;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_attribute.value);
    }
  }

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
                  initialValue: widget.initialAttribute.nameDe,
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
                    _attribute.value = _attribute.value.copyWith(
                      nameDe: () => value.isNotEmpty ? value : null,
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: _attribute,
                  builder: (context, child) {
                    return TextFormField(
                      initialValue: widget.initialAttribute.nameEn,
                      decoration: InputDecoration(
                        labelText: "Name (En)",
                        hintText: _attribute.value.nameDe,
                        constraints: BoxConstraints(maxWidth: fieldWidth),
                      ),
                      onChanged: (value) {
                        _attribute.value = _attribute.value.copyWith(
                          nameEn: () => value.isNotEmpty ? value : null,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  children: [
                    DropdownMenuFormField<AttributeType>(
                      initialSelection: widget.initialAttribute.type,
                      label: Text("Type"),
                      width: fieldWidth,
                      requestFocusOnTap: false,
                      dropdownMenuEntries: [
                        for (final value
                            in widget
                                    .initialAttribute
                                    .type
                                    ?.exchangeableTypes ??
                                AttributeType.values)
                          DropdownMenuEntry(
                            value: value,
                            label: value.name,
                            leadingIcon: Icon(value.icon),
                          ),
                      ],
                      enabled:
                          widget.initialAttribute.type?.hasExchangeableTypes ??
                          true,
                      onSelected: (value) {
                        _attribute.value = _attribute.value.copyWith(
                          type: () => value,
                          unitType:
                              value != AttributeType.number ? () => null : null,
                        );
                        setState(() => {});
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select a type";
                        }
                        return null;
                      },
                    ),
                    if (_attribute.value.type == AttributeType.number)
                      DropdownMenuFormField<UnitType>(
                        initialSelection: widget.initialAttribute.unitType,
                        label: Text("Unit type"),
                        width: fieldWidth,
                        menuHeight: 500,
                        enableFilter: true,
                        enableSearch: false,
                        dropdownMenuEntries: [
                          for (final value in UnitTypes.values)
                            DropdownMenuEntry(value: value, label: value.name),
                        ],
                        onSelected: (value) {
                          _attribute.value = _attribute.value.copyWith(
                            unitType: () => value,
                          );
                        },
                      ),
                  ],
                );
              },
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
                          required: () => value == true ? true : null,
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
                    child: Text(
                      widget.initialAttribute is Attribute ? "Save" : "Create",
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
}
