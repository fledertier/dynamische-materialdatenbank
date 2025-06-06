import 'dart:math';

import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Extrema {
  const Extrema({required this.min, required this.max});

  final num min, max;
}

final valuesExtremaProvider = FutureProvider.family((
  ref,
  String attributeId,
) async {
  final numbers = await ref.watch(valuesProvider(attributeId).future);
  final values = numbers.values.map((number) => (number as UnitNumber).value);
  if (values.isEmpty) {
    return null;
  }
  return Extrema(min: values.reduce(min), max: values.reduce(max));
});

final valuesProvider = FutureProvider.family((ref, String attributeId) async {
  final attribute = await ref.watch(
    attributeProvider(AttributePath(attributeId)).future,
  );
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
  const AttributesArgument(this.attributePaths);

  final Set<AttributePath> attributePaths;

  @override
  bool operator ==(Object other) {
    return other is AttributesArgument &&
        setEquals(other.attributePaths, attributePaths);
  }

  @override
  int get hashCode {
    return Object.hashAllUnordered(attributePaths);
  }
}

final attributeProvider = FutureProvider.family((
  ref,
  AttributePath? path,
) async {
  final attributesById = await ref.watch(attributesProvider.future);
  return getAttribute(attributesById, path);
});

final attributesUsedCountProvider = FutureProvider.family((
  ref,
  AttributesArgument argument,
) async {
  final valuesByIds = await Future.wait([
    for (final path in argument.attributePaths)
      ref.watch(jsonValuesProvider(path.topLevelId).future),
  ]);
  return valuesByIds.expand((valuesById) => valuesById.keys).toSet().length;
});
