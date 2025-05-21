import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../types.dart';
import 'attribute/custom/custom_cards.dart';
import 'placeholder.dart';

final materialServiceProvider = Provider((ref) => MaterialService());

class MaterialService {
  Future<void> createMaterial() async {
    final materialId = generateId();
    final material = {
      Attributes.id: materialId,
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

    await updateMaterial(materialId, material);
  }

  Future<void> updateMaterial(String id, Json data) async {
    await FirebaseFirestore.instance
        .collection(Collections.materials)
        .doc(id)
        .set({Attributes.id: id, ...data}, SetOptions(merge: true));

    for (final attribute in data.keys) {
      await FirebaseFirestore.instance
          .collection(Collections.attributes)
          .doc(attribute)
          .set({id: data[attribute]}, SetOptions(merge: true));
    }
  }

  // todo: should fetch the entire material first
  Future<void> deleteMaterial(Json material) async {
    final id = material[Attributes.id] as String;

    FirebaseFirestore.instance
        .collection(Collections.materials)
        .doc(id)
        .delete();

    for (final attribute in material.keys) {
      FirebaseFirestore.instance
          .collection(Collections.attributes)
          .doc(attribute)
          .update({id: FieldValue.delete()});
    }
  }

  Stream<Map<String, dynamic>> getMaterialStream(String id) {
    return FirebaseFirestore.instance
        .collection(Collections.materials)
        .doc(id)
        .snapshots()
        .map((snapshot) {
          return snapshot.exists ? snapshot.data() ?? {} : {};
        });
  }
}
