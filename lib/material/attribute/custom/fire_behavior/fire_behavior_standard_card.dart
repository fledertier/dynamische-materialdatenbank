import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/text_attribute_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';
import '../../../material_provider.dart';
import '../../cards.dart';
import 'fire_behavior_standard.dart';
import 'fire_behavior_standard_visualization.dart';

class FireBehaviorStandardCard extends ConsumerWidget {
  const FireBehaviorStandardCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value =
        ref.watch(
          materialAttributeValueProvider(
            AttributeArgument(
              materialId: materialId,
              attributeId: Attributes.fireBehaviorStandard,
            ),
          ),
        ) ??
        'B-s2,d1';

    final fireBehavior = FireBehaviorStandard.parse(value);

    return AttributeCard(
      columns: 3,
      label: AttributeLabel(attribute: Attributes.fireBehaviorStandard),
      title: TextAttributeField(
        attributeId: Attributes.fireBehaviorStandard,
        text: value,
        onChanged: (value) {
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            Attributes.fireBehaviorStandard: value,
          });
        },
      ),
      child: FireBehaviorStandardVisualization(fireBehavior),
    );
  }
}
