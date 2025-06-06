import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/light/ray_visualization.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LightAbsorptionCard extends ConsumerWidget {
  const LightAbsorptionCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: materialId,
                  attributePath: AttributePath(Attributes.lightAbsorption),
                ),
              ),
            )
            as UnitNumber? ??
        UnitNumber(value: 0);

    final absorbedRays = (number.value / 10).round();

    return NumberCard(
      materialId: materialId,
      attributeId: Attributes.lightAbsorption,
      size: CardSize.small,
      columns: 1,
      child: RayVisualization(
        incidentRays: 10 - absorbedRays,
        absorbedRays: absorbedRays,
      ),
    );
  }
}
