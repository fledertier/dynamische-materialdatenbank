import 'package:flutter/material.dart';

import 'dropdown_menu_form_field.dart';

class EmptyField extends StatelessWidget {
  const EmptyField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(decoration: InputDecoration(enabled: false));
  }
}

class TextField extends StatelessWidget {
  const TextField({super.key, required this.onChanged, this.required = false});

  final void Function(String? value) onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (required) {
            return "Please enter a text";
          }
        }
        return null;
      },
    );
  }
}

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.onChanged,
    this.required = false,
  });

  final void Function(num? value) onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      onChanged: (value) {
        final number = num.tryParse(value);
        onChanged(number);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (required) {
            return "Please enter a number";
          }
          return null;
        }
        final number = num.tryParse(value);
        if (number == null) {
          return "Invalid number";
        }
        return null;
      },
    );
  }
}

class BooleanField extends StatefulWidget {
  const BooleanField({
    super.key,
    this.initialValue = true,
    required this.onChanged,
    this.required = false,
  });

  final bool? initialValue;
  final void Function(bool? value) onChanged;
  final bool required;

  @override
  State<BooleanField> createState() => _BooleanFieldState();
}

class _BooleanFieldState extends State<BooleanField> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      Future.microtask(() => widget.onChanged(widget.initialValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenuFormField(
      initialSelection: widget.initialValue,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: true, label: "True"),
        DropdownMenuEntry(value: false, label: "False"),
      ],
      onSelected: widget.onChanged,
      enableSearch: false,
      validator: (value) {
        if (value == null) {
          if (widget.required) {
            return "Please select a value";
          }
        }
        return null;
      },
    );
  }
}
