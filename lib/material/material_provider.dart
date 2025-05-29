import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute/cards.dart';
import 'attribute/custom/custom_cards.dart';
import 'attribute/default/country/country.dart';
import 'attribute/default/number/unit_number.dart';
import 'attribute/default/text/translatable_text.dart';
import 'materials_provider.dart';
import 'placeholder.dart';

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

  void createMaterial() {
    final material = {
      Attributes.id: arg,
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

    updateMaterial(material);
  }

  void updateMaterial(Json material) async {
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

  void deleteMaterial() async {
    final doc = ref
        .read(firestoreProvider)
        .collection(Collections.materials)
        .doc(arg);

    final material = (await doc.get()).data();

    if (material == null) {
      return;
    }

    await doc.delete();

    await Future.wait([
      for (final attribute in material.keys)
        ref
            .read(firestoreProvider)
            .collection(Collections.values)
            .doc(attribute)
            .update({arg: FieldValue.delete()}),
    ]);

    ref.invalidateSelf();
  }
}

final jsonValueProvider = Provider.family((ref, AttributeArgument arg) {
  final material = ref.watch(materialProvider(arg.materialId)).value;
  if (material == null) {
    return null;
  }

  final attributes = ref.watch(attributesProvider).value;
  return getJsonAttributeValue(material, attributes, arg.attributeId);
});

final valueProvider = Provider.family((ref, AttributeArgument arg) {
  final json = ref.watch(jsonValueProvider(arg));
  if (json == null) {
    return null;
  }

  final attribute = ref.watch(attributeProvider(arg.attributeId));
  final type = attribute?.type;
  if (type == null) {
    return null;
  }

  return _convert(json, type);
});

Object? _convert(json, AttributeType type) {
  return switch (type) {
    TextAttributeType() => TranslatableText.fromJson(json),
    NumberAttributeType() => UnitNumber.fromJson(json),
    BooleanAttributeType() => json as bool,
    CountryAttributeType() => Country.fromJson(json),
    UrlAttributeType() => Uri.tryParse(json as String),
    ListAttributeType() => _convertList(json, type),
    ObjectAttributeType() => _convertObject(json, type),
    _ =>
      throw UnimplementedError(
        "Converter for attribute type '$type' is not implemented",
      ),
  };
}

List<dynamic> _convertList(json, ListAttributeType type) {
  return switch (type.attribute?.type) {
    TextAttributeType() => List<Json>.from(json).map(TranslatableText.fromJson),
    NumberAttributeType() => List<Json>.from(json).map(UnitNumber.fromJson),
    BooleanAttributeType() => List<bool>.from(json),
    CountryAttributeType() => List.from(
      json,
    ).map((country) => country != null ? Country.fromJson(country) : null),
    UrlAttributeType() =>
      List<String>.from(json).map((url) => Uri.tryParse(url)).nonNulls,
    _ =>
      throw UnimplementedError(
        "Converter for list attribute type '${type.attribute?.type}' is not implemented",
      ),
  }.toList();
}

Map<String, dynamic> _convertObject(json, ObjectAttributeType type) {
  final attributes = type.attributes;
  final converted = <String, dynamic>{};

  for (final attribute in attributes) {
    final value = json[attribute.id];
    if (value != null) {
      converted[attribute.id] = _convert(value, attribute.type);
    }
  }

  return converted;
}

class AttributeArgument {
  const AttributeArgument({
    required this.materialId,
    required this.attributeId,
  });

  final String materialId;
  final String attributeId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttributeArgument &&
        other.materialId == materialId &&
        other.attributeId == attributeId;
  }

  @override
  int get hashCode => materialId.hashCode ^ attributeId.hashCode;

  @override
  String toString() {
    return 'AttributeParameter(material: $materialId, attribute: $attributeId)';
  }
}
