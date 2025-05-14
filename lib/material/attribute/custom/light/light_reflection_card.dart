import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ray_visualization.dart';

class LightReflectionCard extends ConsumerWidget {
  const LightReflectionCard({
    super.key,
    required this.material,
    required this.size,
  });

  final String material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameter = AttributeParameter(
      material: material,
      attribute: Attributes.lightReflection,
    );
    final value = ref.watch(materialAttributeValueProvider(parameter));

    final number = UnitNumber.fromJson(value);
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

class AttributeParameter {
  const AttributeParameter({required this.material, required this.attribute});

  final String material;
  final String attribute;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttributeParameter &&
        other.material == material &&
        other.attribute == attribute;
  }

  @override
  int get hashCode => material.hashCode ^ attribute.hashCode;

  @override
  String toString() {
    return 'AttributeParameter(material: $material, attribute: $attribute)';
  }
}

final materialAttributeValueProvider = Provider.family((
  ref,
  AttributeParameter arg,
) {
  final material = ref.watch(materialStreamProvider(arg.material)).value;
  return material?[arg.attribute];
});
