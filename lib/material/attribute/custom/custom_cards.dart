import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/components/components_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/composition_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/density/areal_density_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/density/density_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/description/description_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/fire_behavior/fire_behavior_standard_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/image/image_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/light/light_absorption_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/light/light_reflection_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/light/light_transmission_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/name/name_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/origin_country_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impressions_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/u_value/u_value_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/w_value/w_value_card.dart';
import 'package:flutter/widgets.dart';

enum CustomCards implements Cards {
  nameCard(
    attributes: {Attributes.name},
    sizes: {CardSize.small, CardSize.large},
  ),
  descriptionCard(
    attributes: {Attributes.description},
    sizes: {CardSize.small, CardSize.large},
  ),
  imageCard(
    attributes: {Attributes.image, Attributes.images},
    sizes: {CardSize.large},
  ),
  lightReflectionCard(
    attributes: {Attributes.lightReflection},
    sizes: {CardSize.large},
  ),
  lightAbsorptionCard(
    attributes: {Attributes.lightAbsorption},
    sizes: {CardSize.large},
  ),
  lightTransmissionCard(
    attributes: {Attributes.lightTransmission},
    sizes: {CardSize.large},
  ),
  uValueCard(attributes: {Attributes.uValue}, sizes: {CardSize.large}),
  wValueCard(attributes: {Attributes.wValue}, sizes: {CardSize.large}),
  originCountryCard(
    attributes: {Attributes.originCountry},
    sizes: {CardSize.small, CardSize.large},
  ),
  compositionCard(
    attributes: {Attributes.composition},
    sizes: {CardSize.small, CardSize.large},
  ),
  fireBehaviorStandardCard(
    attributes: {Attributes.fireBehaviorStandard},
    sizes: {CardSize.large},
  ),
  arealDensityCard(
    attributes: {Attributes.arealDensity},
    sizes: {CardSize.large},
  ),
  densityCard(attributes: {Attributes.density}, sizes: {CardSize.large}),
  componentsCard(
    attributes: {Attributes.components},
    sizes: {CardSize.small, CardSize.large},
  ),
  subjectiveImpressionsCard(
    attributes: {Attributes.subjectiveImpressions},
    sizes: {CardSize.small, CardSize.large},
  );

  const CustomCards({required this.attributes, required this.sizes});

  final Set<String> attributes;
  @override
  final Set<CardSize> sizes;
}

abstract class CustomCardFactory {
  static Widget create(CustomCards card, String materialId, CardSize size) {
    return switch (card) {
      CustomCards.nameCard => NameCard(materialId: materialId, size: size),
      CustomCards.descriptionCard => DescriptionCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.imageCard => ImageCard(materialId: materialId, size: size),
      CustomCards.lightReflectionCard => LightReflectionCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.lightAbsorptionCard => LightAbsorptionCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.lightTransmissionCard => LightTransmissionCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.uValueCard => UValueCard(materialId: materialId, size: size),
      CustomCards.wValueCard => WValueCard(materialId: materialId, size: size),
      CustomCards.originCountryCard => OriginCountryCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.compositionCard => CompositionCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.fireBehaviorStandardCard => FireBehaviorStandardCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.arealDensityCard => ArealDensityCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.densityCard => DensityCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.componentsCard => ComponentsCard(
        materialId: materialId,
        size: size,
      ),
      CustomCards.subjectiveImpressionsCard => SubjectiveImpressionsCard(
        materialId: materialId,
        size: size,
      ),
    };
  }
}
