import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/w_value/water_absorption_visualization.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_attribute_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../types.dart';
import '../../../material_service.dart';
import '../../attribute_card.dart';
import '../../cards.dart';

/// Also known as the water absorption coefficient
class WValueCard extends ConsumerWidget {
  const WValueCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = material[Attributes.wValue] ?? 0;

    return AttributeCard(
      label: AttributeLabel(attribute: Attributes.wValue),
      title: NumberAttributeField(
        attribute: Attributes.wValue,
        value: value.toStringAsFixed(1),
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
