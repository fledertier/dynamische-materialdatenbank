import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types.dart';
import '../../material_service.dart';
import '../cards.dart';
import 'ray_visualization.dart';

class LightAbsorptionCard extends ConsumerWidget {
  const LightAbsorptionCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = material[Attributes.lightAbsorption] ?? 0;

    final absorbedRays = (value / 10).round();

    return AttributeCard(
      label: AttributeLabel(
        attribute: Attributes.lightAbsorption,
        value: value.toStringAsFixed(0),
        unit: '%',
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            Attributes.lightAbsorption: double.tryParse(value) ?? 0,
          });
        },
      ),
      child: RayVisualization(
        incidentRays: 10 - absorbedRays,
        absorbedRays: absorbedRays,
      ),
    );
  }
}
