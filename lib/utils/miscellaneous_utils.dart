import 'dart:convert';
import 'dart:js_interop';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:web/web.dart' as web;

String generateId() {
  return Uuid().v7();
}

extension EnumByName<T extends Enum> on Iterable<T> {
  T? maybeByName(String? name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}

double widthByColumns(int columns) {
  return columns * 158 + (columns - 1) * 16;
}

extension SizeExtension on Size {
  double get area => width * height;
}

extension MenuControllerExtension on MenuController {
  void toggle() => isOpen ? close() : open();
}

extension RandomColor on Color {
  static Color rgb() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}

void downloadJson(dynamic json, String filename) {
  final blob = web.Blob([jsonEncode(json).toJS].toJS);
  downloadBlob(blob, filename);
}

void downloadBlob(web.Blob blob, String filename) {
  final url = web.URL.createObjectURL(blob);
  web.HTMLAnchorElement()
    ..href = url
    ..download = filename
    ..click();
  web.URL.revokeObjectURL(url);
}

extension BoolExtension on bool {
  int toInt() {
    return this ? 1 : 0;
  }
}

extension UriExtension on Uri {
  String toJson() {
    return toString();
  }

  static Uri? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    return Uri.tryParse(json);
  }
}
