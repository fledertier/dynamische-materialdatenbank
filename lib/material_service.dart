import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialServiceProvider = Provider((ref) => MaterialService());

class MaterialService {
  Future<void> createMaterial() async {
    final id = Random().nextInt(4000).toString().padLeft(4, "0");
    final material = {
      "id": id,
      "name": "Material $id",
      "description": "Description of Material $id",
      "weight": double.parse((Random().nextDouble() * 100).toStringAsFixed(2)),
    };

    await updateMaterial(material);
  }

  Future<void> updateMaterial(Map<String, dynamic> material) async {
    assert(material["id"] != null, "Material must have an id");
    final id = material["id"];

    await FirebaseFirestore.instance
        .collection("materials")
        .doc(id)
        .set(material, SetOptions(merge: true));

    for (final attribute in material.keys) {
      await FirebaseFirestore.instance
          .collection("attributes")
          .doc(attribute)
          .set({id: material[attribute]}, SetOptions(merge: true));
    }
  }

  Future<void> deleteMaterial(String id) async {
    final material = await getMaterial(id);

    FirebaseFirestore.instance.collection("materials").doc(id).delete();

    for (final attribute in material.keys) {
      FirebaseFirestore.instance.collection("attributes").doc(attribute).update(
        {id: FieldValue.delete()},
      );
    }
  }

  Future<Map<String, dynamic>> getMaterial(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection("materials").doc(id).get();
    return snapshot.exists ? snapshot.data() ?? {} : {};
  }
}
