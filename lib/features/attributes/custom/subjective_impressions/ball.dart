import 'package:dynamische_materialdatenbank/features/attributes/custom/subjective_impressions/subjective_impression.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class Ball {
  Ball.impression({
    required this.position,
    required this.velocity,
    required this.rotation,
    required SubjectiveImpression this.impression,
  }) : radius = radiusOf(impression),
       color = colorOf(impression);

  Ball.add({required this.position, required this.velocity})
    : rotation = 0,
      radius = 40,
      color = Colors.transparent;

  Vector2 position;
  Vector2 velocity;
  double rotation;
  double radius;
  Color color;
  SubjectiveImpression? impression;
}
