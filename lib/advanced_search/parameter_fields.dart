import 'package:flutter/material.dart';

import '../attributes/attribute_type.dart';
import '../widgets/dropdown_menu_form_field.dart';

class ConditionParameterField extends StatelessWidget {
  const ConditionParameterField({
    super.key,
    required this.type,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  final AttributeType? type;
  final Object? value;
  final void Function(Object? value)? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AttributeType.text || AttributeType.textarea:
        return TextField(
          enabled: enabled,
          initialValue: value as String?,
          onChanged: (value) => onChanged?.call(value),
        );
      case AttributeType.number:
        return NumberField(
          enabled: enabled,
          initialValue: value as num?,
          onChanged: (value) => onChanged?.call(value),
        );
      case AttributeType.boolean:
        return BooleanField(
          enabled: enabled,
          initialValue: value as bool? ?? true,
          onChanged: (value) => onChanged?.call(value),
        );
      default:
        return EmptyField();
    }
  }
}

class TextField extends StatelessWidget {
  const TextField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
  });

  final String? initialValue;
  final void Function(String? value) onChanged;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      initialValue: initialValue,
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
    this.initialValue,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
  });

  final num? initialValue;
  final void Function(num? value) onChanged;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      initialValue: initialValue?.toString(),
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxWidth: 150),
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
    this.initialValue,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
  });

  final bool? initialValue;
  final void Function(bool? value) onChanged;
  final bool required;
  final bool enabled;

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
      enabled: widget.enabled,
      initialSelection: widget.initialValue,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: true, label: "True"),
        DropdownMenuEntry(value: false, label: "False"),
      ],
      onSelected: widget.onChanged,
      enableSearch: false,
      requestFocusOnTap: false,
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

class EmptyField extends StatelessWidget {
  const EmptyField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(decoration: InputDecoration(enabled: false));
  }
}
