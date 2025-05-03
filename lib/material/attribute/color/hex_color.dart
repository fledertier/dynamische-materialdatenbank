import 'dart:ui' show Color;

extension HexColor on Color {
  static Color fromHex(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  String toHex() {
    return '#${toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
