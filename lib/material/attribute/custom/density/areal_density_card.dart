import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';

import 'density_visualization.dart';

class ArealDensityCard extends StatelessWidget {
  const ArealDensityCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context) {
    final number = UnitNumber.fromJson(material[Attributes.arealDensity]);

    return NumberCard(
      material: material[Attributes.id],
      attribute: Attributes.arealDensity,
      size: size,
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 1,
        child: DensityVisualization(density: (number.value / 1000).clamp(0, 1)),
      ),
    );
  }
}
