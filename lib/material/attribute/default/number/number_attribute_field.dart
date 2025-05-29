import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/units.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../widgets/loading_text.dart';
import 'unit_number.dart';

class NumberAttributeField extends ConsumerStatefulWidget {
  const NumberAttributeField({
    super.key,
    required this.attributeId,
    required this.number,
    this.onChanged,
    this.textStyle,
  });

  final String attributeId;
  final UnitNumber number;
  final ValueChanged<UnitNumber>? onChanged;
  final TextStyle? textStyle;

  @override
  ConsumerState<NumberAttributeField> createState() =>
      _NumberAttributeFieldState();
}

class _NumberAttributeFieldState extends ConsumerState<NumberAttributeField> {
  TextEditingController? controller;
  late var number = widget.number;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final textStyle = (widget.textStyle ?? textTheme.titleLarge!).copyWith(
      fontFamily: 'Lexend',
    );

    final attribute = ref.watch(attributeProvider(widget.attributeId)).value;
    final edit = ref.watch(editModeProvider);

    if (attribute == null) {
      return LoadingText(null, style: textStyle, width: 40);
    }

    final numberType = attribute.type as NumberAttributeType;
    final unitType = numberType.unitType;
    final value = toDisplayUnit(number, unitType);
    controller ??= TextEditingController(text: value.toStringAsFlexible());

    return Wrap(
      children: [
        Baseline(
          baseline: textStyle.fontSize!,
          baselineType: TextBaseline.alphabetic,
          child: IntrinsicWidth(
            child: TextField(
              enabled: edit,
              style: textStyle,
              decoration: InputDecoration.collapsed(hintText: '0'),
              controller: controller,
              onChanged: (text) {
                final value = double.tryParse(text) ?? 0.0;
                number = number.copyWith(value: toBaseUnit(value, unitType));
                widget.onChanged?.call(number);
              },
            ),
          ),
        ),
        if (unitType != null)
          Baseline(
            baseline: textStyle.fontSize!,
            baselineType: TextBaseline.alphabetic,
            child: UnitDropdown(
              unitType: unitType,
              selectedUnit: number.displayUnit,
              edit: edit,
              onChanged: (unit) {
                number = number.copyWith(displayUnit: unit);
                widget.onChanged?.call(number);
              },
            ),
          ),
      ],
    );
  }

  num toBaseUnit(num value, UnitType? unitType) {
    if (unitType == null) {
      return value;
    }
    return unitType.convert(value, fromUnit: number.displayUnit);
  }

  num toDisplayUnit(UnitNumber number, UnitType? unitType) {
    if (unitType == null) {
      return number.value;
    }
    return unitType.convert(number.value, toUnit: number.displayUnit);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class UnitDropdown extends StatelessWidget {
  const UnitDropdown({
    super.key,
    required this.unitType,
    this.selectedUnit,
    required this.edit,
    this.onChanged,
  });

  final UnitType unitType;
  final String? selectedUnit;
  final bool edit;
  final ValueChanged<String>? onChanged;

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
            autofocus: unit == selectedUnit,
            onPressed: () {
              onChanged?.call(unit);
            },
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
            borderRadius: BorderRadius.circular(4),
            onTap: controller.toggle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [child!, arrow],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          selectedUnit ?? unitType.base,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
