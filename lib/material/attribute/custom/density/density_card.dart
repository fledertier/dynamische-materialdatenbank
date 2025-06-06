import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/density/density_visualization.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DensityCard extends ConsumerWidget {
  const DensityCard({super.key, required this.materialId, required this.size});

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: materialId,
                  attributePath: AttributePath(Attributes.density),
                ),
              ),
            )
            as UnitNumber? ??
        UnitNumber(value: 0);

    return NumberCard(
      materialId: materialId,
      attributeId: Attributes.density,
      size: CardSize.small,
      columns: 1,
      clip: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: DensityVisualization(
          density: (number.value / 1000).clamp(0, 1),
          isThreeDimensional: true,
        ),
      ),
    );
  }
}
