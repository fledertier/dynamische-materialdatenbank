import 'package:dynamische_materialdatenbank/material/attribute/subjective_impressions/subjective_impressions_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/u_value/u_value_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/w_value/w_value_card.dart';
import 'package:flutter/widgets.dart';

import '../../types.dart';
import 'attribute_cards.dart';
import 'components/components_card.dart';
import 'composition/composition_card.dart';
import 'density/areal_density_card.dart';
import 'density/density_card.dart';
import 'description/description_card.dart';
import 'fire_behavior/fire_behavior_standard_card.dart';
import 'image/image_card.dart';
import 'light/light_absorption_card.dart';
import 'light/light_reflection_card.dart';
import 'light/light_transmission_card.dart';
import 'origin_country/origin_country_card.dart';

abstract class AttributeCardFactory {
  static Widget create(
    AttributeCards card,
    Json material, [
    bool small = false,
  ]) {
    return switch (card) {
      AttributeCards.descriptionCard => DescriptionCard(material),
      AttributeCards.imageCard => ImageCard(material),
      AttributeCards.lightReflectionCard => LightReflectionCard(material),
      AttributeCards.lightAbsorptionCard => LightAbsorptionCard(material),
      AttributeCards.lightTransmissionCard => LightTransmissionCard(material),
      AttributeCards.uValueCard => UValueCard(material),
      AttributeCards.wValueCard => WValueCard(material),
      AttributeCards.originCountryCard => OriginCountryCard(material),
      AttributeCards.compositionCard =>
        small ? CompositionCard.small(material) : CompositionCard(material),
      AttributeCards.componentsCard =>
        small ? ComponentsCard.small(material) : ComponentsCard(material),
      AttributeCards.fireBehaviorStandardCard => FireBehaviorStandardCard(
        material,
      ),
      AttributeCards.arealDensityCard => ArealDensityCard(material),
      AttributeCards.densityCard => DensityCard(material),
      AttributeCards.subjectiveImpressionsCard => SubjectiveImpressionsCard(
        material,
      ),
    };
  }
}
