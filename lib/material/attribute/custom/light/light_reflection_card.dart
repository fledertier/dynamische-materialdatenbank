import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ray_visualization.dart';

class LightReflectionCard extends ConsumerWidget {
  const LightReflectionCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      materialAttributeValueProvider(
        AttributeArgument(
          materialId: materialId,
          attributeId: Attributes.lightReflection,
        ),
      ),
    );

    final number = UnitNumber.fromJson(value);
    final reflectedRays = (number.value / 10).round();

    return NumberCard(
      materialId: materialId,
      attributeId: Attributes.lightReflection,
      size: size,
      child: RayVisualization(
        incidentRays: 10 - reflectedRays,
        reflectedRays: reflectedRays,
      ),
    );
  }
}
