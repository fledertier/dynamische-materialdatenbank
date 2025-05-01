import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/density/density_visualization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types.dart';
import '../../material_service.dart';
import '../attribute_card.dart';

class ArealDensityCard extends ConsumerWidget {
  const ArealDensityCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.arealDensity));
    final value = material[Attributes.arealDensity] ?? 1000;

    return AttributeCard(
      label: AttributeLabel(
        label: attribute?.name,
        value: value.toStringAsFixed(1),
        unit: 'kg/m²',
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial({
            Attributes.id: material[Attributes.id],
            Attributes.arealDensity: double.tryParse(value) ?? 0,
          });
        },
      ),
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 1,
        child: DensityVisualization(density: (value / 1000).clamp(0, 1)),
      ),
    );
  }
}
