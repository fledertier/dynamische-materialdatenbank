import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'density_visualization.dart';

class DensityCard extends ConsumerWidget {
  const DensityCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = material[Attributes.density]?['value'] ?? 1000;

    return NumberCard(
      material: material,
      attribute: Attributes.density,
      size: size,
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 1,
        child: DensityVisualization(
          density: (value / 1000).clamp(0, 1),
          isThreeDimensional: true,
        ),
      ),
    );
  }
}
