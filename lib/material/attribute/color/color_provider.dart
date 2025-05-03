import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'color_service.dart';

final materialColorProvider = Provider.family((ref, String name) {
  final colors = ref.watch(materialColorsStreamProvider).value;
  final color = colors?[name];
  if (color == null) {
    ref.read(colorServiceProvider).requestMaterialColor(name);
  }
  return color;
});

final materialColorsStreamProvider = StreamProvider((ref) {
  return ref.read(colorServiceProvider).getMaterialColorsStream();
});
