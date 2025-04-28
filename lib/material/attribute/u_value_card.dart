import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types.dart';
import '../material_service.dart';
import 'attribute_card.dart';
import 'ray_painter.dart';

class UValueCard extends ConsumerWidget {
  const UValueCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.uValue));
    final value = material[Attributes.uValue] ?? 0;

    final transmittedRays = (value / 6 * 10).clamp(0, 10).round();
    final reflectedRays = 10 - transmittedRays;

    return AttributeCard(
      label: attribute?.name,
      value: value.toStringAsFixed(1),
      unit: 'W/m²K',
      onChanged: (value) {
        ref.read(materialServiceProvider).updateMaterial({
          Attributes.id: material[Attributes.id],
          Attributes.uValue: double.tryParse(value) ?? 0,
        });
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: RayPainter(
            rays: [
              for (int i = 0; i < transmittedRays; i++) Ray.transmitted,
              for (int i = 0; i < reflectedRays; i++) Ray.reflected,
            ],
            rayColor: ColorScheme.of(context).onPrimaryContainer,
            mediumColor: ColorScheme.of(context).primaryContainer,
          ),
        ),
      ),
    );
  }
}
