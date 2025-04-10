import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/attribute_service.dart';

final attributeStreamProvider = StreamProvider.family((ref, String attribute) {
  return ref.read(attributeServiceProvider).getAttributeStream(attribute);
});

final attributeProvider = FutureProvider.family((ref, String attribute) {
  return ref.read(attributeServiceProvider).getAttribute(attribute);
});

final attributesStreamProvider = FutureProvider.family((
  ref,
  AttributesParameter parameter,
) async {
  final materials = <String, Map<String, dynamic>>{};
  for (final attribute in parameter.attributes) {
    final values = await ref.watch(attributeProvider(attribute).future);
    values.forEach((id, value) {
      final material = materials.putIfAbsent(id, () => {"id": id});
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
