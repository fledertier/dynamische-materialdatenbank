import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../material_provider.dart';
import 'water_absorption_visualization.dart';

class WValueCard extends ConsumerWidget {
  const WValueCard({super.key, required this.materialId, required this.size});

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      materialAttributeValueProvider(
        AttributeArgument(
          materialId: materialId,
          attributeId: Attributes.wValue,
        ),
      ),
    );

    final number = UnitNumber.fromJson(value);

    return NumberCard(
      materialId: materialId,
      attributeId: Attributes.wValue,
      size: size,
      spacing: 32,
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: WaterAbsorptionVisualization(value: number.value.toDouble()),
    );
  }
}
