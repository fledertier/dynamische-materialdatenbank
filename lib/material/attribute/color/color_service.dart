import 'dart:async';
import 'dart:ui' show Color;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hex_color.dart';

final colorServiceProvider = Provider((ref) => ColorService());

class ColorService {
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
    final result = await FirebaseFunctions.instanceFor(
      region: region,
    ).httpsCallable(Functions.colorFromName).call({"name": name});
    final hex = result.data as String?;
    if (hex == null) {
      return null;
    }
    final color = HexColor.fromHex(hex);
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
