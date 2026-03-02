import 'dart:ui';

import 'package:vector_math/vector_math.dart';

class Particle {
  static const double minRadius = 10.0;
  static const double maxRadius = 20.0;

  const Particle(this.position);

  final Vector3 position;

  Offset get offset {
    return Offset(position.x, position.y);
  }

  double get radius {
    return lerpDouble(maxRadius, minRadius, position.z / 2)!;
  }
}
