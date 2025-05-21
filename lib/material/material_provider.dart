import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../types.dart';
import 'material_service.dart';

final materialProvider =
    StreamNotifierProvider.family<MaterialNotifier, Json, String>(
      MaterialNotifier.new,
    );

class MaterialNotifier extends FamilyStreamNotifier<Json, String> {
  @override
  Stream<Json> build(String arg) {
    if (arg == exampleMaterial[Attributes.id]) {
      return Stream.value(exampleMaterial);
    }
    return ref.read(materialServiceProvider).getMaterialStream(arg);
  }

  void updateMaterial(Json material) {
    ref.read(materialServiceProvider).updateMaterial(arg, material);
  }
}

final materialAttributeValueProvider = Provider.family((
  ref,
  AttributeArgument arg,
) {
  final material = ref.watch(materialProvider(arg.materialId)).value;
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
