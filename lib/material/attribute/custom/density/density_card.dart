import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_attribute_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../types.dart';
import '../../../material_service.dart';
import '../../attribute_card.dart';
import '../../cards.dart';
import 'density_visualization.dart';

class DensityCard extends ConsumerWidget {
  const DensityCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = material[Attributes.density] ?? 1000;

    return AttributeCard(
      label: AttributeLabel(attribute: Attributes.density),
      title: NumberAttributeField(
        attribute: Attributes.density,
        value: value.toStringAsFixed(1),
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            Attributes.density: double.tryParse(value) ?? 0,
          });
        },
      ),
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
