import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

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
