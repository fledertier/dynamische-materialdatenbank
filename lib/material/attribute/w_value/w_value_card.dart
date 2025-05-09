import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/w_value/water_absorption_visualization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../cards.dart';

/// Also known as the water absorption coefficient
class WValueCard extends ConsumerWidget {
  const WValueCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.wValue));
    final value = material[Attributes.wValue] ?? 0;

    return AttributeCard(
      label: AttributeLabel(
        label: attribute?.name,
        value: value.toStringAsFixed(1),
        unit: 'kg/(m²√h)',
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            Attributes.wValue: double.tryParse(value) ?? 0,
          });
        },
      ),
      spacing: 32,
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: WaterAbsorptionVisualization(value: value),
    );
  }
}
