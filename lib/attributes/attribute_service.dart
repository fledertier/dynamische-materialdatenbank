import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'attribute.dart';

final attributeServiceProvider = Provider((ref) => AttributeService());

class AttributeService {
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
      final id = material[Attributes.id];
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
        .doc(Docs.attributes)
        .set({attribute: FieldValue.delete()}, SetOptions(merge: true));
  }

  Stream<Map<String, Attribute>> getAttributesStream() {
    return FirebaseFirestore.instance
        .collection(Collections.metadata)
        .doc(Docs.attributes)
        .snapshots()
        .map((snapshot) {
          final map = snapshot.dataOrNull() ?? {};
          return map.mapValues((json) => Attribute.fromJson(json));
        });
  }

  Future<void> updateAttribute(Attribute attribute) async {
    final id = attribute.id;
    await FirebaseFirestore.instance
        .collection(Collections.metadata)
        .doc(Docs.attributes)
        .set({id: attribute.toJson()}, SetOptions(merge: true));
  }

  String nearestAvailableAttributeId(
    String name,
    Map<String, Attribute> attributes,
  ) {
    final suffix = RegExp(r"(?:-(\d+))?");
    final pattern = RegExp(RegExp.escape(name) + suffix.pattern);

    final similarIds =
        attributes.keys.where((id) => pattern.hasMatch(id)).toList();

    final usedNumbers =
        similarIds.map((id) {
          final match = pattern.firstMatch(id);
          if (match != null && match.group(0) == id) {
            final digits = match.group(1);
            final number = digits != null ? int.parse(digits) : 0;
            return number;
          }
          return 0;
        }).toSet();

    final nextNumber = usedNumbers.isEmpty ? 0 : usedNumbers.reduce(max) + 1;
    return nextNumber > 0 ? "$name-$nextNumber" : name;
  }
}

extension DocumentSnapshotExtension<T> on DocumentSnapshot<T> {
  T? dataOrNull() => exists ? data() : null;
}
