import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'color_service.dart';

final materialColorProvider = Provider.family((ref, String name) {
  final asyncColors = ref.watch(materialColorsStreamProvider);
  if (asyncColors.isLoading) {
    return null;
  }
  final color = asyncColors.value?[name];
  if (color == null) {
    ref.read(colorServiceProvider).createMaterialColor(name);
  }
  return color;
});

final materialColorsStreamProvider = StreamProvider((ref) {
  return ref.read(colorServiceProvider).getMaterialColorsStream();
});
