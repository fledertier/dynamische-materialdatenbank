import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute_service.dart';

final attributeStreamProvider = StreamProvider.family((ref, String attribute) {
  return ref.read(attributeServiceProvider).getAttributeStream(attribute);
});

final attributeProvider = FutureProvider.family((ref, String attribute) {
  return ref.read(attributeServiceProvider).getAttribute(attribute);
});
