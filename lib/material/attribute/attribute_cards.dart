import '../../constants.dart';

enum AttributeCards {
  descriptionCard([Attributes.description]),
  imageCard([Attributes.image, Attributes.images]),
  lightReflectionCard([Attributes.lightReflection]),
  lightAbsorptionCard([Attributes.lightAbsorption]),
  lightTransmissionCard([Attributes.lightTransmission]),
  uValueCard([Attributes.uValue]),
  wValueCard([Attributes.wValue]),
  originCountryCard([Attributes.originCountry]),
  compositionCard([Attributes.composition]),
  fireBehaviorStandardCard([Attributes.fireBehaviorStandard]),
  arealDensityCard([Attributes.arealDensity]),
  densityCard([Attributes.density]),
  componentsCard([Attributes.components]),
  subjectiveImpressionsCard([Attributes.subjectiveImpressions]);

  const AttributeCards(this.attributes);

  final List<String> attributes;
}
