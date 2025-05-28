import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute.dart';

final attributeServiceProvider = Provider(
  (ref) => AttributeService(FirebaseFirestore.instance),
);

class AttributeService {
  const AttributeService(this.firestore);

  final FirebaseFirestore firestore;

  Stream<Json> getAttributeValuesStream(String attributeId) {
    return firestore
        .collection(Collections.values)
        .doc(attributeId)
        .snapshots()
        .map((snapshot) {
          return snapshot.exists ? snapshot.data() ?? {} : {};
        });
  }

  Future<List<Json>> getMaterialsWithAttribute(String attributeId) async {
    final snapshot =
        await firestore
            .collection(Collections.materials)
            .where(attributeId, isNull: false)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteAttribute(String attributeId) async {
    await _deleteAttributeInMaterials(attributeId);
    await _deleteValuesWithAttribute(attributeId);
    await _deleteAttribute(attributeId);
  }

  Future<void> _deleteAttributeInMaterials(String attributeId) async {
    final materials = await getMaterialsWithAttribute(attributeId);
    for (final material in materials) {
      final materialId = material[Attributes.id];
      firestore.collection(Collections.materials).doc(materialId).update({
        attributeId: FieldValue.delete(),
      });
    }
  }

  Future<void> _deleteValuesWithAttribute(String attributeId) async {
    final topLevelAttributeId = attributeId.split('.').first;
    final subAttributeId = attributeId.split('.').sublist(1).join('.');

    final attributeDoc = firestore
        .collection(Collections.values)
        .doc(topLevelAttributeId);

    if (attributeId == topLevelAttributeId) {
      attributeDoc.delete();
    } else {
      final valuesByMaterialId = (await attributeDoc.get()).data() ?? {};
      attributeDoc.update({
        for (final materialId in valuesByMaterialId.keys)
          '$materialId.$subAttributeId': FieldValue.delete(),
      });
    }
  }

  Future<void> _deleteAttribute(String attributeId) async {
    final topLevelAttributeId = attributeId.split('.').first;

    if (attributeId != topLevelAttributeId) {
      return; // attribute is removed in the attribute dialog
    }

    return firestore
        .collection(Collections.attributes)
        .doc(Docs.attributes)
        .set({attributeId: FieldValue.delete()}, SetOptions(merge: true));
  }

  Stream<Map<String, Attribute>> getAttributesStream() {
    return firestore
        .collection(Collections.attributes)
        .doc(Docs.attributes)
        .snapshots()
        .map((snapshot) {
          final map = snapshot.dataOrNull() ?? {};
          return map.mapValues((json) => Attribute.fromJson(json));
        });
  }

  Future<void> updateAttribute(Attribute attribute) async {
    final id = attribute.id;
    await firestore.collection(Collections.attributes).doc(Docs.attributes).set(
      {id: attribute.toJson()},
      SetOptions(merge: true),
    );
  }
}

extension DocumentSnapshotExtension<T> on DocumentSnapshot<T> {
  T? dataOrNull() => exists ? data() : null;
}
