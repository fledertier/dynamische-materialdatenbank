import 'package:dynamische_materialdatenbank/search/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_provider.dart';
import '../constants.dart';
import '../filter/filter_provider.dart';
import '../filter/filter_service.dart';
import '../search/search_service.dart';
import 'material_service.dart';

final filteredMaterialItemsStreamProvider = FutureProvider((ref) async {
  final query = ref.watch(searchProvider);
  final filterOptions = ref.watch(filterOptionsProvider);
  final attributes = AttributesArgument({
    Attributes.name,
    if (query.isNotEmpty) Attributes.description,
    ...filterOptions.keys,
  });
  var materials = await ref.watch(materialsStreamProvider(attributes).future);
  materials = ref
      .read(searchServiceProvider)
      .search(materials, attributes.attributes, query);
  materials = ref.read(filterServiceProvider).filter(materials, filterOptions);
  return materials;
});

final materialsStreamProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final attributes = await ref.watch(attributesValuesProvider(argument).future);
  return attributes.values.toList();
});

final materialStreamProvider = StreamProvider.family((ref, String id) {
  return ref.read(materialServiceProvider).getMaterialStream(id);
});

final materialAttributeValueProvider = Provider.family((
  ref,
  AttributeArgument arg,
) {
  if (arg.materialId == exampleMaterial[Attributes.id]) {
    return exampleMaterial[arg.attributeId];
  }
  final material = ref.watch(materialStreamProvider(arg.materialId)).value;
  return material?[arg.attributeId];
});

class AttributeArgument {
  const AttributeArgument({
    required this.materialId,
    required this.attributeId,
  });

  final String materialId;
  final String attributeId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttributeArgument &&
        other.materialId == materialId &&
        other.attributeId == attributeId;
  }

  @override
  int get hashCode => materialId.hashCode ^ attributeId.hashCode;

  @override
  String toString() {
    return 'AttributeParameter(material: $materialId, attribute: $attributeId)';
  }
}

final Map<String, dynamic> exampleMaterial = {
  Attributes.id: "example",
  Attributes.name: "Acoustic Wood Wool",
  Attributes.description:
      "BAUX Acoustic Wood Wool is a functional, natural material made from two of the world’s oldest building materials, wood and cement. The combination is simple and ingenious. Wood fiber offers excellent insulation, heat retention and sound absorption. Cement, a proven and popular building material, is the binder that provides strength, moisture resistance and fire protection. Therefore, BAUX acoustic products are versatile and durable in all climates.",
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
