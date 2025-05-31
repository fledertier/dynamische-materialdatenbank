import 'dart:math';

import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute_converter.dart';
import 'attributes_provider.dart';

class Extrema {
  const Extrema({required this.min, required this.max});

  final num min, max;
}

final valuesExtremaProvider = FutureProvider.family((
  ref,
  String attribute,
) async {
  final numbers = await ref.watch(valuesProvider(attribute).future);
  final values = numbers.values.map((number) => (number as UnitNumber).value);
  if (values.isEmpty) {
    return null;
  }
  return Extrema(min: values.reduce(min), max: values.reduce(max));
});

final valuesProvider = FutureProvider.family((ref, String attributeId) async {
  final attribute = await ref.watch(attributeProvider(attributeId).future);
  final values = await ref.watch(jsonValuesProvider(attributeId).future);

  return values.mapValues((json) => fromJson(json, attribute?.type));
});

final jsonValuesProvider = StreamProvider.family((ref, String attributeId) {
  return ref
      .read(firestoreProvider)
      .collection(Collections.values)
      .doc(attributeId)
      .snapshots()
      .map((snapshot) {
        return snapshot.dataOrNull() ?? {};
      });
});

class AttributesArgument {
  const AttributesArgument(this.attributes);

  final Set<String> attributes;

  @override
  bool operator ==(Object other) {
    return other is AttributesArgument &&
        setEquals(other.attributes, attributes);
  }

  @override
  int get hashCode {
    return Object.hashAllUnordered(attributes);
  }
}

final attributeProvider = FutureProvider.family((
  ref,
  String? attributeId,
) async {
  final attributesById = await ref.watch(attributesProvider.future);
  return getAttribute(attributesById, attributeId);
});

final attributesUsedCountProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final valuesByIds = await Future.wait([
    for (final attribute in argument.attributes)
      ref.watch(jsonValuesProvider(attribute).future),
  ]);
  return valuesByIds.expand((valuesById) => valuesById.keys).toSet().length;
});
