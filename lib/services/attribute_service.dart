import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../attributes/attribute.dart';
import '../constants.dart';

final attributeServiceProvider = Provider((ref) => AttributeService());

class AttributeService {
  Future<Map<String, dynamic>> getAttribute(String attribute) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(Collections.attributes)
            .doc(attribute)
            .get();
    return snapshot.exists ? snapshot.data() ?? {} : {};
  }

  Stream<Map<String, dynamic>> getAttributeStream(String attribute) {
    return FirebaseFirestore.instance
        .collection(Collections.attributes)
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
            .collection(Collections.materials)
            .where(attribute, isNull: false)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteAttribute(String attribute) async {
    final materials = await getMaterialsWithAttribute(attribute);

    for (final material in materials) {
      final id = material["id"];
      FirebaseFirestore.instance
          .collection(Collections.materials)
          .doc(id)
          .update({attribute: FieldValue.delete()});
    }

    FirebaseFirestore.instance
        .collection(Collections.attributes)
        .doc(attribute)
        .delete();

    FirebaseFirestore.instance
        .collection(Collections.metadata)
        .doc("attributes")
        .set({attribute: FieldValue.delete()}, SetOptions(merge: true));
  }

  Future<List<Attribute>> getAttributes() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection(Collections.metadata)
            .doc("attributes")
            .get();
    final list = snapshot.dataOrNull()?.includeKeysInValuesAs("id") ?? [];
    return list.map(Attribute.fromJson).toList();
  }

  Stream<List<Attribute>> getAttributesStream() {
    return FirebaseFirestore.instance
        .collection(Collections.metadata)
        .doc("attributes")
        .snapshots()
        .map((snapshot) {
          final list = snapshot.dataOrNull()?.includeKeysInValuesAs("id") ?? [];
          return list.map(Attribute.fromJson).toList();
        });
  }

  Future<void> createAttribute(Json attribute) async {
    final id = Uuid().v7();
    await FirebaseFirestore.instance
        .collection(Collections.metadata)
        .doc("attributes")
        .set({id: attribute}, SetOptions(merge: true));
  }

  Future<void> updateAttribute(Attribute attribute) async {
    final id = attribute.id;
    await FirebaseFirestore.instance
        .collection(Collections.metadata)
        .doc("attributes")
        .set({id: attribute.toJson()}, SetOptions(merge: true));
  }
}

typedef Json = Map<String, dynamic>;

extension on Json {
  List<Json> includeKeysInValuesAs(String attribute) {
    return entries.map((entry) {
      return {attribute: entry.key, ...entry.value as Json};
    }).toList();
  }
}

extension DocumentSnapshotExtension<T> on DocumentSnapshot<T> {
  T? dataOrNull() => exists ? data() : null;
}
