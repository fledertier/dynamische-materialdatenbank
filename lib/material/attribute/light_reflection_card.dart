import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types.dart';
import '../material_service.dart';
import 'ray_visualization.dart';

class LightReflectionCard extends ConsumerWidget {
  const LightReflectionCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.lightReflection));
    final value = material[Attributes.lightReflection] ?? 0;

    final reflectedRays = (value / 10).round();

    return AttributeCard(
      label: AttributeLabel(
        label: attribute?.name,
        value: value.toStringAsFixed(0),
        unit: '%',
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial({
            Attributes.id: material[Attributes.id],
            Attributes.lightReflection: double.tryParse(value) ?? 0,
          });
        },
      ),
      child: RayVisualization(
        incidentRays: 10 - reflectedRays,
        reflectedRays: reflectedRays,
      ),
    );
  }
}
