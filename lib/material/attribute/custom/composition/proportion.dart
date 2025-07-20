import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:flutter/material.dart';

class Proportion {
  const Proportion({required this.name, required this.share, this.color});

  final TranslatableText name;
  final UnitNumber share;
  final Color? color;
}
