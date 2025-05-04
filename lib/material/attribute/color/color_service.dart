import 'dart:async';
import 'dart:ui' show Color;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../image/image_search_service.dart';
import 'hex_color.dart';

final colorServiceProvider = Provider((ref) {
  return ColorService(
    imageSearchService: ref.watch(imageSearchServiceProvider),
  );
});

class ColorService {
  const ColorService({required this.imageSearchService});

  final ImageSearchService imageSearchService;

  Stream<Map<String, Color>> getMaterialColorsStream() {
    return FirebaseFirestore.instance
        .collection(Collections.colors)
        .doc(Docs.materials)
        .snapshots()
        .map((snapshot) {
          final map = Map<String, String>.from(snapshot.data() ?? {});
          return map.mapValues(HexColor.fromHex);
        });
  }

  Future<Color?> createMaterialColor(String name) async {
    final result = await imageSearchService.searchImages(name);
    final color = result?.color;
    if (color == null) {
      return null;
    }
    setMaterialColor(name, color);
    return color;
  }

  void setMaterialColor(String name, Color color) {
    FirebaseFirestore.instance
        .collection(Collections.colors)
        .doc(Docs.materials)
        .set({name: color.toHex()}, SetOptions(merge: true));
  }
}
