import 'dart:math';
import 'dart:ui';

import '../../../../types.dart';

class SubjectiveImpression {
  const SubjectiveImpression({
    required this.nameDe,
    required this.nameEn,
    required this.count,
  });

  final String nameDe;
  final String? nameEn;
  final int count;

  String get name => nameDe;

  factory SubjectiveImpression.fromJson(Json json) {
    return SubjectiveImpression(
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      count: json['count'],
    );
  }

  Json toJson() {
    return {'nameDe': nameDe, 'nameEn': nameEn, 'count': count};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubjectiveImpression &&
        other.nameDe == nameDe &&
        other.nameEn == nameEn &&
        other.count == count;
  }

  @override
  int get hashCode {
    return Object.hash(nameDe, nameEn, count);
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
  final random = Random(impression.name.hashCode);
  return _colors[random.nextInt(_colors.length)];
}

double radiusOf(SubjectiveImpression impression) {
  return impression.count * 10 + 20;
}
