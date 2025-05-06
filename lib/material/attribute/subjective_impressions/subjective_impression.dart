import 'dart:math';
import 'dart:ui';

import '../../../types.dart';

class SubjectiveImpression {
  const SubjectiveImpression({required this.name, required this.count});

  final String name;
  final int count;

  factory SubjectiveImpression.fromJson(Json json) {
    return SubjectiveImpression(name: json['name'], count: json['count']);
  }

  Json toJson() {
    return {'name': name, 'count': count};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
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
  final random = Random(impression.name.hashCode);
  return _colors[random.nextInt(_colors.length)];
}
