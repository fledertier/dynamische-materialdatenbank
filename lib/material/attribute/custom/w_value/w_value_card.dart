import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'water_absorption_visualization.dart';

/// Also known as the water absorption coefficient
class WValueCard extends ConsumerWidget {
  const WValueCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = material[Attributes.wValue] ?? 0;

    return NumberCard(
      material: material,
      attribute: Attributes.wValue,
      size: size,
      spacing: 32,
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: WaterAbsorptionVisualization(value: value),
    );
  }
}
