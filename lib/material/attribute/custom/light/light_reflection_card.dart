import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';

import 'ray_visualization.dart';

class LightReflectionCard extends StatelessWidget {
  const LightReflectionCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context) {
    final number = UnitNumber.fromJson(material[Attributes.lightReflection]);
    final reflectedRays = (number.value / 10).round();

    return NumberCard(
      material: material,
      attribute: Attributes.lightReflection,
      size: size,
      child: RayVisualization(
        incidentRays: 10 - reflectedRays,
        reflectedRays: reflectedRays,
      ),
    );
  }
}
