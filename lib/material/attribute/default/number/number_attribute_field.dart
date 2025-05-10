import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class NumberAttributeField extends ConsumerStatefulWidget {
  const NumberAttributeField({
    super.key,
    required this.attribute,
    this.value,
    this.onChanged,
  });

  final String attribute;
  final String? value;
  final ValueChanged<String>? onChanged;

  @override
  ConsumerState<NumberAttributeField> createState() =>
      _NumberAttributeFieldState();
}

class _NumberAttributeFieldState extends ConsumerState<NumberAttributeField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    final attribute = ref.watch(attributeProvider(widget.attribute));
    final edit = ref.watch(editModeProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        IntrinsicWidth(
          child: TextField(
            enabled: edit,
            style: textTheme.titleLarge?.copyWith(fontFamily: 'Lexend'),
            decoration: InputDecoration.collapsed(hintText: '0'),
            controller: controller,
            onChanged: widget.onChanged,
          ),
        ),
        if (attribute?.unitType != null)
          UnitDropdown(unitType: attribute!.unitType!, edit: edit),
      ],
    );
  }
}

class UnitDropdown extends StatelessWidget {
  const UnitDropdown({super.key, required this.unitType, required this.edit});

  final UnitType unitType;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    return MenuAnchor(
      alignmentOffset: Offset(-12, 0),
      menuChildren: [
        for (final unit in unitType.units)
          MenuItemButton(
            requestFocusOnHover: false,
            onPressed: () {},
            child: Text(unit),
          ),
      ],
      builder: (context, controller, child) {
        if (!edit) {
          return child!;
        }
        final arrow = Icon(
          Symbols.arrow_drop_down,
          size: textTheme.bodyMedium?.fontSize,
          color: colorScheme.onSurfaceVariant,
        );
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: controller.toggle,
            child: Row(children: [child!, arrow]),
          ),
        );
      },
      child: Text(
        unitType.base,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
