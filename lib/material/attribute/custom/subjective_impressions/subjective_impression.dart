import 'dart:math';
import 'dart:ui';

import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';

class SubjectiveImpression {
  const SubjectiveImpression({required this.name, required this.count});

  final TranslatableText name;
  final UnitNumber count;

  factory SubjectiveImpression.fromJson(Json json) {
    return SubjectiveImpression(
      name: TranslatableText.fromJson(
        json[Attributes.subjectiveImpressionName],
      ),
      count: UnitNumber.fromJson(json[Attributes.subjectiveImpressionCount]),
    );
  }

  Json toJson() {
    return {
      Attributes.subjectiveImpressionName: name.toJson(),
      Attributes.subjectiveImpressionCount: count.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is SubjectiveImpression &&
        other.name == name &&
        other.count == count;
  }

  @override
  int get hashCode {
    return Object.hash(name, count);
  }
}

final _colors = [
  Color(0xFFA6ACDC),
  Color(0xFF7DA4DB),
  Color(0xFF8E9867),
  Color(0xFFE1927F),
  Color(0xFFEEDBD1),
  Color(0xFFF3DE8A),
];

Color colorOf(SubjectiveImpression impression) {
  final random = Random(impression.name.value.hashCode);
  return _colors[random.nextInt(_colors.length)];
}

double radiusOf(SubjectiveImpression impression) {
  return impression.count.value * 10 + 20;
}
