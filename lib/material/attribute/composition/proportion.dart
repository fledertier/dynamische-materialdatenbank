import 'package:flutter/material.dart';

class Proportion {
  const Proportion({
    required this.nameDe,
    required this.nameEn,
    required this.share,
    required this.color,
  });

  String get name => nameDe;

  final String nameDe;
  final String? nameEn;
  final num share;
  final Color color;
}
