import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'color_service.dart';

final requestingMaterialColorProvider = Provider.family((ref, String name) {
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

final materialColorProvider = Provider.family((ref, String name) {
  final asyncColors = ref.watch(materialColorsStreamProvider);
  return asyncColors.value?[name];
});

final materialColorsStreamProvider = StreamProvider((ref) {
  return ref.read(colorServiceProvider).getMaterialColorsStream();
});
