import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ray_visualization.dart';

class LightTransmissionCard extends ConsumerWidget {
  const LightTransmissionCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = material[Attributes.lightTransmission] ?? 0;

    final transmittedRays = (value / 10).round();

    return NumberCard(
      material: material,
      attribute: Attributes.lightTransmission,
      size: size,
      child: RayVisualization(
        incidentRays: 10 - transmittedRays,
        transmittedRays: transmittedRays,
      ),
    );
  }
}
