import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card_search.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:dynamische_materialdatenbank/material/placeholder.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .doc(arg)
        .snapshots()
        .map((snapshot) {
          return snapshot.exists ? snapshot.data() ?? {} : {};
        });
  }

  Future<void> createMaterial() async {
    final attributes = await ref.read(attributesProvider.future);
    final requiredAttributes =
        attributes.values.where((attribute) => attribute.required).toSet();

    final cards = [
      for (final attribute in requiredAttributes)
        findCardsForAttribute(attribute, {CardSize.large}).first,
    ];
    cards.sortBy((card) => card.attributeId == Attributes.name ? 0 : 1);

    final material = {
      for (final attribute in requiredAttributes)
        attribute.id: toJson(
          defaultValueForAttributeType(attribute.type.id),
          attribute.type,
        ),
      Attributes.id: arg,
      Attributes.name:
          TranslatableText(
            valueDe: 'Unbenanntes Material',
            valueEn: 'Unnamed Material',
          ).toJson(),
      Attributes.cardSections:
          CardSections(
            primary: [CardSection(cards: cards)],
            secondary: [],
          ).toJson(),
    };

    await updateMaterial(material);
  }

  void createRandomMaterial() {
    final material = {
      Attributes.id: arg,
      Attributes.name: randomName(),
      Attributes.description: randomDescription(),
      if (Random().nextBool()) Attributes.recyclable: randomBoolean(),
      if (Random().nextBool()) Attributes.biodegradable: randomBoolean(),
      if (Random().nextBool()) Attributes.biobased: randomBoolean(),
      if (Random().nextBool()) Attributes.manufacturer: randomManufacturer(),
    };

    updateMaterial(material);
  }

  Future<void> updateMaterial(Json material) async {
    await ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .doc(arg)
        .set({Attributes.id: arg, ...material}, SetOptions(merge: true));

    for (final attribute in material.keys) {
      await ref
          .read(firestoreProvider)
          .collection(Collections.values)
          .doc(attribute)
          .set({arg: material[attribute]}, SetOptions(merge: true));
    }
  }

  Future<void> deleteMaterial() async {
    final doc = ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .doc(arg);

    final material = (await doc.get()).data();

    await doc.delete();

    if (material == null) {
      return;
    }

    await Future.wait([
      for (final attribute in material.keys)
        ref
            .read(firestoreProvider)
            .collection(Collections.values)
            .doc(attribute)
            .set({arg: FieldValue.delete()}, SetOptions(merge: true)),
    ]);

    ref.invalidateSelf();
  }
}

final jsonValueProvider = Provider.family((ref, AttributeArgument arg) {
  final material = ref.watch(materialProvider(arg.materialId)).value;
  if (material == null) {
    return null;
  }

  final attributesById = ref.watch(attributesProvider).value;
  return getJsonAttributeValue(material, attributesById, arg.attributePath);
});

final valueProvider = Provider.family((ref, AttributeArgument arg) {
  final json = ref.watch(jsonValueProvider(arg));
  final attribute = ref.watch(attributeProvider(arg.attributePath)).value;

  return fromJson(json, attribute?.type);
});

class AttributeArgument {
  const AttributeArgument({
    required this.materialId,
    required this.attributePath,
  });

  final String materialId;
  final AttributePath attributePath;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttributeArgument &&
        other.materialId == materialId &&
        other.attributePath == attributePath;
  }

  @override
  int get hashCode => Object.hash(materialId, attributePath);

  @override
  String toString() {
    return 'AttributeParameter(material: $materialId, attributePath: $attributePath)';
  }
}
