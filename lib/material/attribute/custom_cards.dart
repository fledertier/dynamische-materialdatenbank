import 'package:dynamische_materialdatenbank/material/attribute/description/description_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/subjective_impressions/subjective_impressions_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/u_value/u_value_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/w_value/w_value_card.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';
import '../../types.dart';
import 'cards.dart';
import 'components/components_card.dart';
import 'composition/composition_card.dart';
import 'density/areal_density_card.dart';
import 'density/density_card.dart';
import 'fire_behavior/fire_behavior_standard_card.dart';
import 'image/image_card.dart';
import 'light/light_absorption_card.dart';
import 'light/light_reflection_card.dart';
import 'light/light_transmission_card.dart';
import 'name/name_card.dart';
import 'origin_country/origin_country_card.dart';

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
    sizes: {CardSize.small, CardSize.large},
  ),
  lightReflectionCard(
    attributes: {Attributes.lightReflection},
    sizes: {CardSize.small, CardSize.large},
  ),
  lightAbsorptionCard(
    attributes: {Attributes.lightAbsorption},
    sizes: {CardSize.small, CardSize.large},
  ),
  lightTransmissionCard(
    attributes: {Attributes.lightTransmission},
    sizes: {CardSize.small, CardSize.large},
  ),
  uValueCard(
    attributes: {Attributes.uValue},
    sizes: {CardSize.small, CardSize.large},
  ),
  wValueCard(
    attributes: {Attributes.wValue},
    sizes: {CardSize.small, CardSize.large},
  ),
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
    sizes: {CardSize.small, CardSize.large},
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
  static Widget create(CustomCards card, Json material, CardSize size) {
    return switch (card) {
      CustomCards.nameCard => NameCard(material: material, size: size),
      CustomCards.descriptionCard => DescriptionCard(
        material: material,
        size: size,
      ),
      CustomCards.imageCard => ImageCard(material: material, size: size),
      CustomCards.lightReflectionCard => LightReflectionCard(
        material: material,
        size: size,
      ),
      CustomCards.lightAbsorptionCard => LightAbsorptionCard(
        material: material,
        size: size,
      ),
      CustomCards.lightTransmissionCard => LightTransmissionCard(
        material: material,
        size: size,
      ),
      CustomCards.uValueCard => UValueCard(material: material, size: size),
      CustomCards.wValueCard => WValueCard(material: material, size: size),
      CustomCards.originCountryCard => OriginCountryCard(
        material: material,
        size: size,
      ),
      CustomCards.compositionCard => CompositionCard(
        material: material,
        size: size,
      ),
      CustomCards.fireBehaviorStandardCard => FireBehaviorStandardCard(
        material: material,
        size: size,
      ),
      CustomCards.arealDensityCard => ArealDensityCard(
        material: material,
        size: size,
      ),
      CustomCards.densityCard => DensityCard(material: material, size: size),
      CustomCards.componentsCard => ComponentsCard(
        material: material,
        size: size,
      ),
      CustomCards.subjectiveImpressionsCard => SubjectiveImpressionsCard(
        material: material,
        size: size,
      ),
    };
  }
}
