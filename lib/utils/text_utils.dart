import 'dart:math';

import 'package:flutter/widgets.dart';

extension StringExtension on String {
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  String capitalize() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String insert(int index, String value) {
    if (index < 0 || index > length) {
      throw RangeError.index(index, this);
    }
    return substring(0, index) + value + substring(index);
  }

  int count(String char) => characters.where((c) => c == char).length;
}

extension TextRangeExtensions on TextRange {
  bool contains(int index) {
    return index >= start && index < end;
  }

  bool within(TextRange range) {
    return start >= range.start && end <= range.end;
  }

  TextSelection get asSelection {
    return TextSelection(baseOffset: start, extentOffset: end);
  }

  TextRange normalize() {
    return TextRange(start: min(start, end), end: max(start, end));
  }
}

extension RegExpMatchExtension on RegExpMatch {
  String? get text => group(0);

  TextRange get range => TextRange(start: start, end: end);
}

extension NumberExtension on num {
  String toStringAsFlexible([int maxDecimals = 6]) {
    final string = toStringAsFixed(maxDecimals);
    return string.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
