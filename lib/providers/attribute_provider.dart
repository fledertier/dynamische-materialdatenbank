import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../services/attribute_service.dart';

class Extrema {
  const Extrema({required this.min, required this.max});

  final double min, max;
}

final attributeExtremaProvider = FutureProvider.family((
  ref,
  String attribute,
) async {
  final values = await ref.watch(
    attributeValuesStreamProvider(attribute).future,
  );
  final numbers = values.values.map((value) => value as double);
  if (numbers.isEmpty) {
    return null;
  }
  return Extrema(min: numbers.reduce(min), max: numbers.reduce(max));
});

final attributeValuesStreamProvider = StreamProvider.family((
  ref,
  String attribute,
) {
  return ref.read(attributeServiceProvider).getAttributeStream(attribute);
});

final attributeValuesProvider = FutureProvider.family((ref, String attribute) {
  return ref.read(attributeServiceProvider).getAttribute(attribute);
});

final attributesValuesStreamProvider = FutureProvider.family((
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
  AttributesParameter(this.attributes);

  final Set<String> attributes;

  @override
  bool operator ==(Object other) {
    return other is AttributesParameter &&
        setEquals(other.attributes, attributes);
  }

  @override
  int get hashCode {
    return Object.hashAllUnordered(attributes);
  }
}

final attributesProvider = FutureProvider((ref) {
  return ref.read(attributeServiceProvider).getAttributes();
});

final attributesStreamProvider = StreamProvider((ref) {
  return ref.read(attributeServiceProvider).getAttributesStream();
});

final attributeProvider = Provider.family((ref, String attribute) {
  return ref.watch(attributesProvider).value?[attribute];
});
