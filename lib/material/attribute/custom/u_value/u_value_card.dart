import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/light/ray_visualization.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../material_provider.dart';

class UValueCard extends ConsumerWidget {
  const UValueCard({super.key, required this.materialId, required this.size});

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      materialAttributeValueProvider(
        AttributeArgument(
          materialId: materialId,
          attributeId: Attributes.uValue,
        ),
      ),
    );

    final number = UnitNumber.fromJson(value);
    final transmittedRays = (number.value / 6 * 10).clamp(0, 10).round();

    return NumberCard(
      materialId: materialId,
      attributeId: Attributes.uValue,
      size: CardSize.small,
      columns: 1,
      child: RayVisualization(
        transmittedRays: transmittedRays,
        reflectedRays: 10 - transmittedRays,
      ),
    );
  }
}
