import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../material_provider.dart';
import 'number_attribute_field.dart';
import 'unit_number.dart';

class NumberCard extends ConsumerWidget {
  const NumberCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.spacing = 16,
    this.clip = Clip.none,
    this.childPadding = const EdgeInsets.all(16),
    this.child,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final double spacing;
  final Clip clip;
  final EdgeInsets childPadding;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final value = ref.watch(
      materialAttributeValueProvider(
        AttributeArgument(materialId: materialId, attributeId: attributeId),
      ),
    );
    final number = UnitNumber.fromJson(value);

    return AttributeCard(
      label: AttributeLabel(attribute: attributeId),
      title: NumberAttributeField(
        key: ValueKey(number.displayUnit),
        attributeId: attributeId,
        number: number,
        textStyle: switch (size) {
          CardSize.small => textTheme.titleLarge,
          CardSize.large => textTheme.displayMedium,
        },
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterialById(materialId, {
            attributeId: number.copyWith(value: value).toJson(),
          });
        },
        onUnitChanged: (unit) {
          ref.read(materialServiceProvider).updateMaterialById(materialId, {
            attributeId: number.copyWith(displayUnit: unit).toJson(),
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
