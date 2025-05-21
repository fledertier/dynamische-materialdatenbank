import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:dynamische_materialdatenbank/material/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../types.dart';
import 'attribute/cards.dart';
import 'attribute/custom/custom_cards.dart';

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
    return FirebaseFirestore.instance
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
      Attributes.cardSections:
          CardSections(
            primary: [
              CardSection(
                cards: [
                  CardData.fromCustomCard(CustomCards.nameCard),
                  CardData.fromCustomCard(CustomCards.descriptionCard),
                ],
              ),
              CardSection(
                cards: [
                  CardData.fromCustomCard(CustomCards.lightAbsorptionCard),
                ],
              ),
            ],
            secondary: [CardSection(cards: [])],
          ).toJson(),
      if (Random().nextBool()) Attributes.recyclable: Random().nextBool(),
      if (Random().nextBool()) Attributes.biodegradable: Random().nextBool(),
      if (Random().nextBool()) Attributes.biobased: Random().nextBool(),
      if (Random().nextBool()) Attributes.manufacturer: randomManufacturer(),
      if (Random().nextBool()) Attributes.weight: randomWeight(),
    };

    updateMaterial(material);
  }

  void updateMaterial(Json material) async {
    await FirebaseFirestore.instance
        .collection(Collections.materials)
        .doc(arg)
        .set({Attributes.id: arg, ...material}, SetOptions(merge: true));

    for (final attribute in material.keys) {
      await FirebaseFirestore.instance
          .collection(Collections.attributes)
          .doc(attribute)
          .set({arg: material[attribute]}, SetOptions(merge: true));
    }
  }

  void deleteMaterial() async {
    final doc = FirebaseFirestore.instance
        .collection(Collections.materials)
        .doc(arg);

    final material = (await doc.get()).data();

    if (material == null) {
      return;
    }

    await doc.delete();

    await Future.wait([
      for (final attribute in material.keys)
        FirebaseFirestore.instance
            .collection(Collections.attributes)
            .doc(attribute)
            .update({arg: FieldValue.delete()}),
    ]);

    ref.invalidateSelf();
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
