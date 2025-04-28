import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types.dart';
import '../material_service.dart';
import 'ray_painter.dart';

class LightAbsorptionCard extends ConsumerWidget {
  const LightAbsorptionCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.lightAbsorption));
    final value = material[Attributes.lightAbsorption] ?? 0;

    final absorbedRays = (value / 10).round();
    final nonAbsorbedRays = 10 - absorbedRays;

    return AttributeCard(
      label: attribute?.name,
      value: value.toStringAsFixed(0),
      unit: '%',
      onChanged: (value) {
        ref.read(materialServiceProvider).updateMaterial({
          Attributes.id: material[Attributes.id],
          Attributes.lightAbsorption: double.tryParse(value) ?? 0,
        });
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: RayPainter(
            rays: [
              for (int i = 0; i < nonAbsorbedRays; i++) Ray.incident,
              for (int i = 0; i < absorbedRays; i++) Ray.absorbed,
            ],
            rayColor: ColorScheme.of(context).onPrimaryContainer,
            mediumColor: ColorScheme.of(context).primaryContainer,
          ),
        ),
      ),
    );
  }
}
