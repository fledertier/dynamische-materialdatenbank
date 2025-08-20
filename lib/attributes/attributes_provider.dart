import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attributesProvider =
    StreamNotifierProvider<AttributesNotifier, Map<String, Attribute>>(
      AttributesNotifier.new,
    );

class AttributesNotifier extends StreamNotifier<Map<String, Attribute>> {
  @override
  Stream<Map<String, Attribute>> build() => getAttributesStream();

  Future<List<Json>> _getMaterialsWithAttribute(AttributePath path) async {
    final snapshot = await ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .where(path.toString(), isNull: false)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteAttribute(AttributePath path) async {
    await _deleteAttributeInMaterials(path);
    await _deleteValuesWithAttribute(path);
    await _deleteAttribute(path);
  }

  Future<void> _deleteAttributeInMaterials(AttributePath path) async {
    final materials = await _getMaterialsWithAttribute(path);
    for (final material in materials) {
      final materialId = material[Attributes.id];
      await ref
          .read(firestoreProvider)
          .collection(Collections.materials)
          .doc(materialId)
          .update({path.toString(): FieldValue.delete()});
    }
  }

  Future<void> _deleteValuesWithAttribute(AttributePath path) async {
    final subAttributePath = path - path.topLevelId;

    final attributeDoc = ref
        .read(firestoreProvider)
        .collection(Collections.values)
        .doc(path.topLevelId);

    if (path.isTopLevel) {
      await attributeDoc.delete();
    } else {
      final valuesByMaterialId = (await attributeDoc.get()).data() ?? {};
      await attributeDoc.set({
        for (final materialId in valuesByMaterialId.keys)
          '$materialId.$subAttributePath': FieldValue.delete(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> _deleteAttribute(AttributePath path) async {
    if (!path.isTopLevel) {
      return; // attribute is removed in the attribute dialog
    }

    return ref
        .read(firestoreProvider)
        .collection(Collections.attributes)
        .doc(Docs.attributes)
        .set({path.toString(): FieldValue.delete()}, SetOptions(merge: true));
  }

  Stream<Map<String, Attribute>> getAttributesStream() {
    return ref
        .read(firestoreProvider)
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
    await ref
        .read(firestoreProvider)
        .collection(Collections.attributes)
        .doc(Docs.attributes)
        .set({id: attribute.toJson()}, SetOptions(merge: true));
  }
}

extension DocumentSnapshotExtension<T> on DocumentSnapshot<T> {
  T? dataOrNull() => exists ? data() : null;
}
