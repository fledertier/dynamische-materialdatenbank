import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../custom/image/image_search_service.dart';
import 'hex_color.dart';

final materialColorProvider =
    NotifierProvider.family<MaterialColorNotifier, Color?, String>(
      MaterialColorNotifier.new,
    );

class MaterialColorNotifier extends FamilyNotifier<Color?, String> {
  @override
  Color? build(String arg) {
    final asyncColors = ref.watch(materialColorsStreamProvider);
    if (asyncColors.isLoading) {
      return null;
    }
    final color = asyncColors.value?[arg];
    if (color == null) {
      createColor(arg);
    }
    return color;
  }

  void createColor(String name) async {
    final result = await ref
        .read(imageSearchServiceProvider)
        .searchImages(name);
    final color = result?.color;
    if (color == null) {
      debugPrint('Failed to create color for $name');
    } else {
      updateColor(color);
    }
  }

  void updateColor(Color color) {
    FirebaseFirestore.instance
        .collection(Collections.colors)
        .doc(Docs.materials)
        .set({arg: color.toHex()}, SetOptions(merge: true));
  }
}

final materialColorsStreamProvider = StreamProvider((ref) {
  return FirebaseFirestore.instance
      .collection(Collections.colors)
      .doc(Docs.materials)
      .snapshots()
      .map((snapshot) {
        final map = Map<String, String>.from(snapshot.data() ?? {});
        return map.mapValues(HexColor.fromHex);
      });
});
