import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_service.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'number_attribute_field.dart';
import 'unit_number.dart';

class NumberCard extends ConsumerWidget {
  const NumberCard({
    super.key,
    required this.material,
    required this.attribute,
    required this.size,
    this.spacing = 16,
    this.clip = Clip.none,
    this.childPadding = const EdgeInsets.all(16),
    this.child,
  });

  final Json material;
  final String attribute;
  final CardSize size;
  final double spacing;
  final Clip clip;
  final EdgeInsets childPadding;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = UnitNumber.fromJson(material[attribute]);

    return AttributeCard(
      label: AttributeLabel(attribute: attribute),
      title: NumberAttributeField(
        key: ValueKey(number.unit),
        attribute: attribute,
        number: number,
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            attribute: number.copyWith(value: value).toJson(),
          });
        },
        onUnitChanged: (unit) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            attribute: number.copyWith(unit: unit).toJson(),
          });
        },
      ),
      columns: switch (size) {
        CardSize.small => 2,
        CardSize.large => 1,
      },
      spacing: spacing,
      clip: clip,
      childPadding: childPadding,
      child: child,
    );
  }
}
