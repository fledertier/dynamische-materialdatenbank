import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../cards.dart';
import '../light/ray_visualization.dart';

class UValueCard extends ConsumerWidget {
  const UValueCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.uValue));
    final value = material[Attributes.uValue] ?? 0;

    final transmittedRays = (value / 6 * 10).clamp(0, 10).round();

    return AttributeCard(
      label: AttributeLabel(
        label: attribute?.name,
        value: value.toStringAsFixed(1),
        unit: 'W/m²K',
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            Attributes.uValue: double.tryParse(value) ?? 0,
          });
        },
      ),
      child: RayVisualization(
        transmittedRays: transmittedRays,
        reflectedRays: 10 - transmittedRays,
      ),
    );
  }
}
