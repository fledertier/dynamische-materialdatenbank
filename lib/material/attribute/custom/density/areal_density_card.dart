import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../material_provider.dart';
import 'density_visualization.dart';

class ArealDensityCard extends ConsumerWidget {
  const ArealDensityCard({
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
          attributeId: Attributes.arealDensity,
        ),
      ),
    );
    final number = UnitNumber.fromJson(value);

    return NumberCard(
      materialId: materialId,
      attributeId: Attributes.arealDensity,
      size: CardSize.small,
      columns: 1,
      clip: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: DensityVisualization(density: (number.value / 1000).clamp(0, 1)),
      ),
    );
  }
}
