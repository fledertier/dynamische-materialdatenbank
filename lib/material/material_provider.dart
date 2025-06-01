import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_converter.dart';
import 'materials_provider.dart';
import 'placeholder.dart';

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
    return ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .doc(arg)
        .snapshots()
        .map((snapshot) {
          return snapshot.exists ? snapshot.data() ?? {} : {};
        });
  }

  void createMaterial() {
    final material = {
      Attributes.id: arg,
      Attributes.name: randomName(),
      Attributes.description: randomDescription(),
      if (Random().nextBool()) Attributes.recyclable: Random().nextBool(),
      if (Random().nextBool()) Attributes.biodegradable: Random().nextBool(),
      if (Random().nextBool()) Attributes.biobased: Random().nextBool(),
      if (Random().nextBool()) Attributes.manufacturer: randomManufacturer(),
    };

    updateMaterial(material);
  }

  Future<void> updateMaterial(Json material) async {
    await ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .doc(arg)
        .set({Attributes.id: arg, ...material}, SetOptions(merge: true));

    for (final attribute in material.keys) {
      await ref
          .read(firestoreProvider)
          .collection(Collections.values)
          .doc(attribute)
          .set({arg: material[attribute]}, SetOptions(merge: true));
    }
  }

  Future<void> deleteMaterial() async {
    final doc = ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .doc(arg);

    final material = (await doc.get()).data();

    await doc.delete();

    if (material == null) {
      return;
    }

    await Future.wait([
      for (final attribute in material.keys)
        ref
            .read(firestoreProvider)
            .collection(Collections.values)
            .doc(attribute)
            .set({arg: FieldValue.delete()}, SetOptions(merge: true)),
    ]);

    ref.invalidateSelf();
  }
}

final jsonValueProvider = Provider.family((ref, AttributeArgument arg) {
  final material = ref.watch(materialProvider(arg.materialId)).value;
  if (material == null) {
    return null;
  }

  final attributes = ref.watch(attributesProvider).value;
  return getJsonAttributeValue(material, attributes, arg.attributeId);
});

final valueProvider = Provider.family((ref, AttributeArgument arg) {
  final json = ref.watch(jsonValueProvider(arg));
  final attribute = ref.watch(attributeProvider(arg.attributeId)).value;

  return fromJson(json, attribute?.type);
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
