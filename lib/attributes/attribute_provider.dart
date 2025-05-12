import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'attribute_service.dart';

class Extrema {
  const Extrema({required this.min, required this.max});

  final double min, max;
}

final attributeExtremaProvider = FutureProvider.family((
  ref,
  String attribute,
) async {
  final values = await ref.watch(attributeValuesProvider(attribute).future);
  final numbers = values.values.map((value) => value as double);
  if (numbers.isEmpty) {
    return null;
  }
  return Extrema(min: numbers.reduce(min), max: numbers.reduce(max));
});

final attributeValuesProvider = StreamProvider.family((ref, String attribute) {
  return ref.read(attributeServiceProvider).getAttributeStream(attribute);
});

final attributesValuesProvider = FutureProvider.family((
  ref,
  AttributesParameter parameter,
) async {
  final materials = <String, Map<String, dynamic>>{};
  for (final attribute in parameter.attributes) {
    final values = await ref.watch(attributeValuesProvider(attribute).future);
    values.forEach((id, value) {
      final material = materials.putIfAbsent(id, () => {Attributes.id: id});
      material[attribute] = value;
    });
  }
  return materials;
});

class AttributesParameter {
  const AttributesParameter(this.attributes);

  final Set<String> attributes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AttributesParameter &&
        setEquals(other.attributes, attributes);
  }

  @override
  int get hashCode {
    return Object.hashAllUnordered(attributes);
  }
}

final attributesProvider = StreamProvider((ref) {
  return ref.read(attributeServiceProvider).getAttributesStream();
});

final attributeProvider = Provider.family((ref, String? attribute) {
  return ref.watch(attributesProvider).value?[attribute];
});
