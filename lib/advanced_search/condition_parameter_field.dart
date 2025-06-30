import 'package:dynamische_materialdatenbank/attributes/attributeValue.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/boolean/boolean.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionParameterField extends ConsumerWidget {
  const ConditionParameterField({
    super.key,
    required this.value,
    required this.attributePath,
    this.onChanged,
    this.enabled = true,
  });

  final AttributePath? attributePath;
  final Object? value;
  final ValueChanged<AttributeValue?>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(attributePath)).value;
    final type = attribute?.type.id;

    return switch (type) {
      AttributeType.text => TextField(
        enabled: enabled,
        initialValue: value as TranslatableText?,
        onChanged: (value) => onChanged?.call(value),
      ),
      AttributeType.number => NumberField(
        enabled: enabled,
        initialValue: value as UnitNumber?,
        onChanged: (value) => onChanged?.call(value),
      ),
      AttributeType.boolean => BooleanField(
        enabled: enabled,
        initialValue: value as Boolean?,
        onChanged: (value) => onChanged?.call(value),
      ),
      _ => EmptyField(),
    };
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

  final TranslatableText? initialValue;
  final void Function(TranslatableText? value) onChanged;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      initialValue: initialValue?.value.toString(),
      onChanged: (value) {
        onChanged(value.isNotEmpty ? TranslatableText(valueDe: value) : null);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (required) {
            return 'Please enter a text';
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

  final UnitNumber? initialValue;
  final void Function(UnitNumber? value) onChanged;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      initialValue: initialValue?.value.toString(),
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxWidth: 150),
      ),
      onChanged: (value) {
        final number = num.tryParse(value) ?? 0;
        onChanged(UnitNumber(value: number));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (required) {
            return 'Please enter a number';
          }
          return null;
        }
        final number = num.tryParse(value);
        if (number == null) {
          return 'Invalid number';
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

  final Boolean? initialValue;
  final void Function(Boolean? value) onChanged;
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
    return DropdownMenuFormField<bool>(
      enabled: widget.enabled,
      initialSelection: widget.initialValue?.value ?? true,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: true, label: 'True'),
        DropdownMenuEntry(value: false, label: 'False'),
      ],
      onSelected: (value) {
        widget.onChanged(Boolean(value: value ?? true));
      },
      enableSearch: false,
      requestFocusOnTap: false,
      validator: (value) {
        if (value == null) {
          if (widget.required) {
            return 'Please select a value';
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
