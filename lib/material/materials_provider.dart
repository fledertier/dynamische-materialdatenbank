import 'package:dynamische_materialdatenbank/search/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_provider.dart';
import '../constants.dart';
import '../filter/filter_provider.dart';
import '../filter/filter_service.dart';
import '../search/search_service.dart';
import '../types.dart';

// todo: delete this
final filteredMaterialsProvider = FutureProvider((ref) async {
  final query = ref.watch(searchProvider);
  final filterOptions = ref.watch(filterOptionsProvider);
  final attributes = AttributesArgument({
    Attributes.name,
    if (query.isNotEmpty) Attributes.description,
    ...filterOptions.keys,
  });
  var materials = await ref.watch(materialsProvider(attributes).future);
  materials = ref
      .read(searchServiceProvider)
      .search(materials, attributes.attributes, query);
  materials = ref.read(filterServiceProvider).filter(materials, filterOptions);
  return materials;
});

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
  for (final attribute in argument.attributes) {
    final values = await ref.watch(jsonValuesProvider(attribute).future);
    values.forEach((id, value) {
      final material = materials.putIfAbsent(id, () => {Attributes.id: id});
      material[attribute] = value;
    });
  }
  return materials;
});

final Json exampleMaterial = {
  Attributes.id: "example",
  Attributes.name: {"valueDe": "Acoustic Wood Wool"},
  Attributes.description: {
    "valueDe":
        "BAUX Acoustic Wood Wool is a functional, natural material made from two of the world’s oldest building materials, wood and cement. The combination is simple and ingenious. Wood fiber offers excellent insulation, heat retention and sound absorption. Cement, a proven and popular building material, is the binder that provides strength, moisture resistance and fire protection. Therefore, BAUX acoustic products are versatile and durable in all climates.",
  },
  Attributes.density: {'value': 800},
  Attributes.arealDensity: {'value': 800},
  Attributes.lightAbsorption: {'value': 56},
  Attributes.lightReflection: {'value': 37},
  Attributes.lightTransmission: {'value': 28},
  Attributes.uValue: {'value': 2},
  Attributes.wValue: {'value': 3.6},
  Attributes.fireBehaviorStandard: "C-s2,d1",
  Attributes.originCountry: ["SE"],
};
