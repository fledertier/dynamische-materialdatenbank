abstract class Pages {
  static const signIn = 'signIn';
  static const signUp = 'signUp';
  static const materials = 'materials';
  static const material = 'material';
  static const attributes = 'attributes';
  static const customSearch = 'custom-search';
}

abstract class Collections {
  static const materials = 'materials';
  static const values = 'values';
  static const attributes = 'attributes';
  static const colors = 'colors';
}

abstract class Docs {
  static const materials = 'materials';
  static const attributes = 'attributes';
}

abstract class Attributes {
  static const id = 'id';
  static const name = 'name';
  static const description = 'description';
  static const recyclable = 'recyclable';
  static const biodegradable = 'biodegradable';
  static const biobased = 'biobased';
  static const manufacturer = 'manufacturer';
  static const manufacturerName = 'name-1';
  static const lightTransmission = 'light transmission';
  static const lightAbsorption = 'light absorption';
  static const lightReflection = 'light reflection';
  static const uValue = 'u-value';
  static const wValue = 'w-value';
  static const composition = '01973a80-8ae1-75ed-ae14-c442187b3955';
  static const compositionCategory = '01973a7f-996f-7d2c-808c-facf1b23abed';
  static const compositionShare = '01973a80-26ff-7bee-bbc8-c93911d3fa2c';
  static const components = '01973a81-f146-7f9b-97c1-97f8b393996a';
  static const componentId = 'id';
  static const componentName = '01973a81-5717-732f-99c0-97481e1954c5';
  static const componentShare = '01973a81-b8b3-7214-b729-877d3d6cb394';
  static const fireBehaviorStandard = '01973a83-3199-7457-80c9-18fda49d92ec';
  static const arealDensity = 'areal density';
  static const density = 'density';
  static const images = '0197c15a-3f4e-7ee4-9bd7-2d9288244074';
  static const image = '0197c1d4-79c9-7e48-8208-5b7fc09c51c9';
  static const subjectiveImpressions = '01973a53-3ad6-7e35-b596-3fb50f93cf96';
  static const originCountry = '01973a84-5f56-71dc-9c18-dc25fc865b33';
  static const cardSections = 'cardSections';
}

const region = 'us-east1';

abstract class Functions {
  static const search = 'search';
  static const chat = 'chat';
}

abstract class Environments {
  static const development = 'development';
  static const production = 'production';
}

const environment = String.fromEnvironment('environment');
