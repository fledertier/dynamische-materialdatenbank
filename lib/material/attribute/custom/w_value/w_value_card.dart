import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';

import 'water_absorption_visualization.dart';

/// Also known as the water absorption coefficient
class WValueCard extends StatelessWidget {
  const WValueCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context) {
    final number = UnitNumber.fromJson(material[Attributes.wValue]);

    return NumberCard(
      material: material[Attributes.id],
      attribute: Attributes.wValue,
      size: size,
      spacing: 32,
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: WaterAbsorptionVisualization(value: number.value.toDouble()),
    );
  }
}
