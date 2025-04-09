import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute.dart';
import '../constants.dart';

final attributeServiceProvider = Provider((ref) => AttributeService());

class AttributeService {
  Future<Map<String, dynamic>> getAttribute(String attribute) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(Collections.attribute)
            .doc(attribute)
            .get();
    return snapshot.exists ? snapshot.data() ?? {} : {};
  }

  Stream<Map<String, dynamic>> getAttributeStream(String attribute) {
    return FirebaseFirestore.instance
        .collection(Collections.attribute)
        .doc(attribute)
        .snapshots()
        .map((snapshot) {
          return snapshot.exists ? snapshot.data() ?? {} : {};
        });
  }

  Future<List<Map<String, dynamic>>> getMaterialsWithAttribute(
    String attribute,
  ) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(Collections.material)
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
      FirebaseFirestore.instance
          .collection(Collections.material)
          .doc(id)
          .update({attribute: FieldValue.delete()});
    }

    FirebaseFirestore.instance
        .collection(Collections.attribute)
        .doc(attribute)
        .delete();
  }

  Future<List<Attribute>> getAttributes() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(Collections.attributes)
            .withConverter(
              fromFirestore: (snapshot, options) {
                return Attribute.fromJson(snapshot.data()!);
              },
              toFirestore: (attribute, options) {
                return attribute.toJson();
              },
            )
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
