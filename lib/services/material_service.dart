import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../placeholder.dart';

final materialServiceProvider = Provider((ref) => MaterialService());

class MaterialService {
  Future<void> createMaterial() async {
    final id = Uuid().v7();
    final material = {
      Attributes.id: id,
      Attributes.name: randomName(),
      Attributes.description: randomDescription(),
      if (Random().nextBool()) Attributes.recyclable: Random().nextBool(),
      if (Random().nextBool()) Attributes.biodegradable: Random().nextBool(),
      if (Random().nextBool()) Attributes.biobased: Random().nextBool(),
      if (Random().nextBool()) Attributes.manufacturer: "Manufacturer ${Random().nextInt(10)}",
      if (Random().nextBool()) Attributes.weight: double.parse((Random().nextDouble() * 100).toStringAsFixed(2)),
    };

    await updateMaterial(material);
  }

  Future<void> updateMaterial(Map<String, dynamic> material) async {
    assert(material[Attributes.id] != null, "Material must have an id");
    final id = material[Attributes.id];

    await FirebaseFirestore.instance
        .collection(Collections.materials)
        .doc(id)
        .set(material, SetOptions(merge: true));

    for (final attribute in material.keys) {
      await FirebaseFirestore.instance
          .collection(Collections.attributes)
          .doc(attribute)
          .set({id: material[attribute]}, SetOptions(merge: true));
    }
  }

  Future<void> deleteMaterial(String id) async {
    final material = await getMaterial(id);

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

  Future<Map<String, dynamic>> getMaterial(String id) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(Collections.materials)
            .doc(id)
            .get();
    return snapshot.exists ? snapshot.data() ?? {} : {};
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
