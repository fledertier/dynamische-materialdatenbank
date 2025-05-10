import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../types.dart';
import '../../../material_service.dart';
import '../../attribute_card.dart';
import '../../cards.dart';
import 'number_attribute_field.dart';

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
    final value = material[attribute] ?? 0;

    return AttributeCard(
      label: AttributeLabel(attribute: attribute),
      title: NumberAttributeField(
        attribute: attribute,
        value: value.toStringAsFixed(1),
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            attribute: double.tryParse(value) ?? 0,
          });
        },
      ),
      spacing: spacing,
      clip: clip,
      childPadding: childPadding,
      child: child,
    );
  }
}
