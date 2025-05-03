import 'dart:async';
import 'dart:ui' show Color;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../debouncer.dart';
import 'hex_color.dart';

final colorServiceProvider = Provider((ref) => ColorService());

class ColorService {
  final debounce = Debouncer(delay: Duration(milliseconds: 200));
  final requestedMaterialColors = <String>{};

  Stream<Map<String, Color>> getMaterialColorsStream() {
    return FirebaseFirestore.instance
        .collection(Collections.colors)
        .doc(Docs.materials)
        .snapshots()
        .map((snapshot) {
          final map = Map<String, String>.from(snapshot.data() ?? {});
          return map
              .whereValues(ColorStatus.isSuccess)
              .mapValues(HexColor.fromHex);
        });
  }

  void requestMaterialColor(String name) {
    requestedMaterialColors.add(name);
    debounce(() {
      if (requestedMaterialColors.isNotEmpty) {
        requestMaterialColors(requestedMaterialColors.toList());
        requestedMaterialColors.clear();
      }
    });
  }

  void requestMaterialColors(List<String> names) {
    FirebaseFirestore.instance
        .collection(Collections.colors)
        .doc(Docs.materials)
        .set({
          for (final name in names) name: ColorStatus.pending,
        }, SetOptions(merge: true));
  }

  void setMaterialColor(String name, String color) {
    FirebaseFirestore.instance
        .collection(Collections.colors)
        .doc(Docs.materials)
        .set({name: color}, SetOptions(merge: true));
  }
}

abstract class ColorStatus {
  static const pending = "pending";
  static const error = "error";

  static bool isSuccess(String status) => status.startsWith("#");

  static bool isPending(String status) => status == pending;

  static bool isError(String status) => status == error;
}
