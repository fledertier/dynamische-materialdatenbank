import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/density/density_visualization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../cards.dart';

class DensityCard extends ConsumerWidget {
  const DensityCard({super.key, required this.material, required this.size});

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.density));
    final value = material[Attributes.density] ?? 1000;

    return AttributeCard(
      label: AttributeLabel(
        label: attribute?.name,
        value: value.toStringAsFixed(1),
        unit: 'kg/m³',
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
