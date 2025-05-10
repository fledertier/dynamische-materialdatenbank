import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/light/ray_visualization.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';

class UValueCard extends StatelessWidget {
  const UValueCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context) {
    final number = UnitNumber.fromJson(material[Attributes.uValue]);
    final transmittedRays = (number.value / 6 * 10).clamp(0, 10).round();

    return NumberCard(
      material: material,
      attribute: Attributes.uValue,
      size: size,
      child: RayVisualization(
        transmittedRays: transmittedRays,
        reflectedRays: 10 - transmittedRays,
      ),
    );
  }
}
