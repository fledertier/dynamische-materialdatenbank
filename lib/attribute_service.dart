import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attributeServiceProvider = Provider((ref) => AttributeService());

class AttributeService {
  Future<Map<String, dynamic>> getAttribute(String attribute) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection("attributes")
            .doc(attribute)
            .get();
    return snapshot.exists ? snapshot.data() ?? {} : {};
  }

  Stream<Map<String, dynamic>> getAttributeStream(String attribute) {
    return FirebaseFirestore.instance
        .collection("attributes")
        .doc(attribute)
        .snapshots()
        .map((snapshot) {
          return snapshot.exists ? snapshot.data() ?? {} : {};
        });
  }

  Future<List<Map<String, dynamic>>> getMaterialsWithAttribute(String attribute) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection("materials")
            .where(attribute, isNull: false)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteAttribute(
    String attribute,
    List<Map<String, dynamic>> materials,
  ) async {
    for (final material in materials) {
      final id = material["id"];
      FirebaseFirestore.instance.collection("materials").doc(id).update({
        attribute: FieldValue.delete(),
      });
    }

    FirebaseFirestore.instance.collection("attributes").doc(attribute).delete();
  }
}
