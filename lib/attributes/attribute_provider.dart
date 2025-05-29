import 'dart:math';

import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attributes_provider.dart';

class Extrema {
  const Extrema({required this.min, required this.max});

  final double min, max;
}

final valuesExtremaProvider = FutureProvider.family((
  ref,
  String attribute,
) async {
  final values = await ref.watch(valuesProvider(attribute).future);
  final numbers = values.values.map((value) => value['value'] as double);
  if (numbers.isEmpty) {
    return null;
  }
  return Extrema(min: numbers.reduce(min), max: numbers.reduce(max));
});

final valuesProvider = StreamProvider.family((ref, String attributeId) {
  return ref
      .read(firestoreProvider)
      .collection(Collections.values)
      .doc(attributeId)
      .snapshots()
      .map((snapshot) {
        return snapshot.exists ? snapshot.data() ?? {} : {};
      });
});

class AttributesArgument {
  const AttributesArgument(this.attributes);

  final Set<String> attributes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AttributesArgument &&
        setEquals(other.attributes, attributes);
  }

  @override
  int get hashCode {
    return Object.hashAllUnordered(attributes);
  }
}

final attributeProvider = Provider.family((ref, String? attributeId) {
  final attributesById = ref.watch(attributesProvider).value;
  return getAttribute(attributesById, attributeId);
});

final attributesUsedCountProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final valuesByIds = await Future.wait([
    for (final attribute in argument.attributes)
      ref.watch(valuesProvider(attribute).future),
  ]);
  return valuesByIds.expand((valuesById) => valuesById.keys).toSet().length;
});
