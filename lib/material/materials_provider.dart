import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/components/component.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/composition.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/material_category.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impression.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialsProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final materialsById = await ref.watch(materialsByIdProvider(argument).future);
  return materialsById.values.toList();
});

final materialsByIdProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final materials = <String, Json>{};
  for (final path in argument.attributePaths) {
    final values = await ref.watch(jsonValuesProvider(path.topLevelId).future);
    values.forEach((id, value) {
      final material = materials.putIfAbsent(id, () => {Attributes.id: id});
      material[path.topLevelId] = value;
    });
  }
  return materials;
});

final Json exampleMaterial = {
  Attributes.id: 'example',
  Attributes.name: TranslatableText(valueDe: 'Acoustic Wood Wool').toJson(),
  Attributes.description:
      TranslatableText(
        valueDe:
            'BAUX Acoustic Wood Wool is a functional, natural material made from two of the world’s oldest building materials, wood and cement. The combination is simple and ingenious. Wood fiber offers excellent insulation, heat retention and sound absorption. Cement, a proven and popular building material, is the binder that provides strength, moisture resistance and fire protection. Therefore, BAUX acoustic products are versatile and durable in all climates.',
      ).toJson(),
  Attributes.density: UnitNumber(value: 800).toJson(),
  Attributes.arealDensity: UnitNumber(value: 800).toJson(),
  Attributes.lightAbsorption: UnitNumber(value: 56).toJson(),
  Attributes.lightReflection: UnitNumber(value: 37).toJson(),
  Attributes.lightTransmission: UnitNumber(value: 28).toJson(),
  Attributes.uValue: UnitNumber(value: 2).toJson(),
  Attributes.wValue: UnitNumber(value: 3.6).toJson(),
  Attributes.fireBehaviorStandard:
      TranslatableText.fromValue('C-s2,d1').toJson(),
  Attributes.originCountry: [TranslatableText.fromValue('SE').toJson()],
  Attributes.subjectiveImpressions: [
    SubjectiveImpression(
      name: TranslatableText(valueDe: 'rau', valueEn: 'rough'),
      count: UnitNumber(value: 4),
    ).toJson(),
    SubjectiveImpression(
      name: TranslatableText(valueDe: 'glatt', valueEn: 'smooth'),
      count: UnitNumber(value: 1),
    ).toJson(),
    SubjectiveImpression(
      name: TranslatableText(valueDe: 'kalt', valueEn: 'cold'),
      count: UnitNumber(value: 2),
    ).toJson(),
    SubjectiveImpression(
      name: TranslatableText(valueDe: 'warm', valueEn: 'warm'),
      count: UnitNumber(value: 3),
    ).toJson(),
    SubjectiveImpression(
      name: TranslatableText(valueDe: 'weich', valueEn: 'soft'),
      count: UnitNumber(value: 1),
    ).toJson(),
    SubjectiveImpression(
      name: TranslatableText(valueDe: 'hart', valueEn: 'hard'),
      count: UnitNumber(value: 2),
    ).toJson(),
  ],
  Attributes.composition: [
    CompositionElement(
      category: MaterialCategory.minerals,
      share: UnitNumber(value: 58),
    ).toJson(),
    CompositionElement(
      category: MaterialCategory.woods,
      share: UnitNumber(value: 40),
    ).toJson(),
    CompositionElement(
      category: MaterialCategory.plastics,
      share: UnitNumber(value: 2),
    ).toJson(),
  ],
  Attributes.components: [
    Component(
      id: '1234',
      name: TranslatableText(
        valueDe: 'Portlandzement',
        valueEn: 'Portland cement',
      ),
      share: UnitNumber(value: 44),
    ).toJson(),
    Component(
      id: '2345',
      name: TranslatableText(
        valueDe: 'Schwedische Fichte',
        valueEn: 'Wood Swedish fir',
      ),
      share: UnitNumber(value: 31),
    ).toJson(),
    Component(
      id: '3456',
      name: TranslatableText(valueDe: 'Wasser', valueEn: 'Water'),
      share: UnitNumber(value: 12),
    ).toJson(),
    Component(
      id: '4567',
      name: TranslatableText(
        valueDe: 'Kalksteinmehl',
        valueEn: 'Limestone powder',
      ),
      share: UnitNumber(value: 9),
    ).toJson(),
    Component(
      id: '5678',
      name: TranslatableText(
        valueDe: 'Farbe, wasserbasiert',
        valueEn: 'Paint, water based',
      ),
      share: UnitNumber(value: 2),
    ).toJson(),
  ],
};
