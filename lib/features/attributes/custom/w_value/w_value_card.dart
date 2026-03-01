import 'package:dynamische_materialdatenbank/features/attributes/models/cards.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/w_value/water_absorption_visualization.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/features/material/providers/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WValueCard extends ConsumerWidget {
  const WValueCard({super.key, required this.materialId, required this.size});

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: materialId,
                  attributePath: AttributePath(Attributes.wValue),
                ),
              ),
            )
            as UnitNumber? ??
        UnitNumber(value: 0);

    return NumberCard(
      materialId: materialId,
      attributeId: Attributes.wValue,
      size: CardSize.small,
      columns: 1,
      spacing: 32,
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: WaterAbsorptionVisualization(value: number.value.toDouble()),
    );
  }
}
