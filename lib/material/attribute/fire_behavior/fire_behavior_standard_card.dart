import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../types.dart';
import '../../material_service.dart';
import 'fire_behavior_standard.dart';
import 'fire_behavior_standard_visualization.dart';

class FireBehaviorStandardCard extends ConsumerWidget {
  const FireBehaviorStandardCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = material[Attributes.fireBehaviorStandard] ?? 'B-s2,d1';
    final fireBehavior = FireBehaviorStandard.parse(value);

    return AttributeCard(
      columns: 3,
      label: AttributeLabel(
        label: 'Fire Behavior (EN 13501-1)',
        value: value,
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial({
            Attributes.id: material[Attributes.id],
            Attributes.fireBehaviorStandard: value,
          });
        },
      ),
      child: FireBehaviorStandardVisualization(fireBehavior),
    );
  }
}
