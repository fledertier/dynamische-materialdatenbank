import 'package:flutter/material.dart';

class EmptyField extends StatelessWidget {
  const EmptyField({super.key});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(enabled: false),
    );
  }
}

class TextField extends StatelessWidget {
  const TextField({super.key, required this.onChanged});

  final void Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(onChanged: onChanged);
  }
}

class NumberField extends StatelessWidget {
  const NumberField({super.key, required this.onChanged});

  final void Function(num? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
    );
  }
}

class BooleanField extends StatelessWidget {
  const BooleanField({super.key, required this.onChanged});

  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: true,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: true, label: "True"),
        DropdownMenuEntry(value: false, label: "False"),
      ],
      onSelected: onChanged,
    );
  }
}
