import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
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
    this.textStyle,
    this.columns,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final double spacing;
  final Clip clip;
  final EdgeInsets childPadding;
  final Widget? child;
  final TextStyle? textStyle;
  final int? columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);

    final number =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: materialId,
                  attributeId: attributeId,
                ),
              ),
            )
            as UnitNumber? ??
        UnitNumber(value: 0);

    return AttributeCard(
      label: AttributeLabel(attribute: attributeId),
      title: NumberAttributeField(
        key: ValueKey(number.displayUnit),
        attributeId: attributeId,
        number: number,
        textStyle:
            textStyle ??
            switch (size) {
              CardSize.small => textTheme.titleLarge,
              CardSize.large => textTheme.displayLarge,
            },
        onChanged: (number) {
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            attributeId: number.toJson(),
          });
        },
      ),
      columns:
          columns ??
          switch (size) {
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
