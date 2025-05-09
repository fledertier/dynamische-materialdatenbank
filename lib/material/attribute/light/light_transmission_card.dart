import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types.dart';
import '../../material_service.dart';
import '../cards.dart';
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
    final attribute = ref.watch(
      attributeProvider(Attributes.lightTransmission),
    );
    final value = material[Attributes.lightTransmission] ?? 0;

    final transmittedRays = (value / 10).round();

    return AttributeCard(
      label: AttributeLabel(
        label: attribute?.name,
        value: value.toStringAsFixed(0),
        unit: '%',
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            Attributes.lightTransmission: double.tryParse(value) ?? 0,
          });
        },
      ),
      child: RayVisualization(
        incidentRays: 10 - transmittedRays,
        transmittedRays: transmittedRays,
      ),
    );
  }
}
