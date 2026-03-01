import 'package:dynamische_materialdatenbank/features/attributes/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/cards.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/density/density_visualization.dart';
import 'package:dynamische_materialdatenbank/features/material/providers/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final number =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: materialId,
                  attributePath: AttributePath(Attributes.arealDensity),
                ),
              ),
            )
            as UnitNumber? ??
        UnitNumber(value: 0);

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
