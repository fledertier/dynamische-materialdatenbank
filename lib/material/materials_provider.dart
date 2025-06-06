import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialsProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final materialsById = await ref.watch(materialsByIdProvider(argument).future);
  return materialsById.values.toList();
});

final materialsByIdProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final materials = <String, Json>{};
  for (final path in argument.attributePaths) {
    final values = await ref.watch(jsonValuesProvider(path.topLevelId).future);
    values.forEach((id, value) {
      final material = materials.putIfAbsent(id, () => {Attributes.id: id});
      material[path.topLevelId] = value;
    });
  }
  return materials;
});

final Json exampleMaterial = {
  Attributes.id: 'example',
  Attributes.name: {'valueDe': 'Acoustic Wood Wool'},
  Attributes.description: {
    'valueDe':
        'BAUX Acoustic Wood Wool is a functional, natural material made from two of the world’s oldest building materials, wood and cement. The combination is simple and ingenious. Wood fiber offers excellent insulation, heat retention and sound absorption. Cement, a proven and popular building material, is the binder that provides strength, moisture resistance and fire protection. Therefore, BAUX acoustic products are versatile and durable in all climates.',
  },
  Attributes.density: {'value': 800},
  Attributes.arealDensity: {'value': 800},
  Attributes.lightAbsorption: {'value': 56},
  Attributes.lightReflection: {'value': 37},
  Attributes.lightTransmission: {'value': 28},
  Attributes.uValue: {'value': 2},
  Attributes.wValue: {'value': 3.6},
  Attributes.fireBehaviorStandard:
      TranslatableText(valueDe: 'C-s2,d1').toJson(),
  Attributes.originCountry: ['SE'],
};
