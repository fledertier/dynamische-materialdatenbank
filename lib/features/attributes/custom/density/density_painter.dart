import 'dart:math';
import 'dart:ui';

import 'package:dynamische_materialdatenbank/features/attributes/custom/density/particle.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class DensityPainter extends CustomPainter {
  static const int gridSize = 3;

  const DensityPainter(
    this.density, {
    this.highlightColor = Colors.white,
    required this.foregroundColor,
    required this.backgroundColor,
    this.isThreeDimensional = false,
    this.seed = 0,
  });

  final double density;
  final Color highlightColor;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool isThreeDimensional;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final particles = createParticles(size);

    int byDepth(Particle a, Particle b) => b.position.z.compareTo(a.position.z);
    particles.sort(byDepth);

    for (final particle in particles) {
      drawParticle(particle, canvas);
    }
  }

  void drawParticle(Particle particle, Canvas canvas) {
    final paint = createPaint(particle);
    canvas.drawCircle(particle.offset, particle.radius, paint);
  }

  Paint createPaint(Particle particle) {
    if (isThreeDimensional) {
      final gradient = RadialGradient(
        center: Alignment(-0.2, -0.2),
        colors: [highlightColor, foregroundColor],
      );
      final shader = gradient.createShader(
        Rect.fromCircle(center: particle.offset, radius: particle.radius),
      );
      return Paint()..shader = shader;
    }
    final color = Color.lerp(foregroundColor, highlightColor, 0.4)!;
    return Paint()..color = color;
  }

  List<Particle> createParticles(Size size) {
    final particles = <Particle>[];
    final random = Random(seed);

    final count = gridSize * gridSize;
    final cellWidth = size.width / gridSize;
    final cellHeight = size.height / gridSize;

    final scale = lerpDouble(1.5, 0.8, density)!;
    final center = Vector3(size.width / 2, size.height / 2, 0);

    for (int i = 0; i < count; i++) {
      final gx = i % gridSize;
      final gy = i ~/ gridSize;

      final x = (gx + 0.5) * cellWidth - size.width / 2;
      final y = (gy + 0.5) * cellHeight - size.height / 2;
      final z = 1.0;

      final offset = Vector3(x, y, z) * scale;

      final jitter = Vector3(
        (random.nextDouble() - 0.5) * 200,
        (random.nextDouble() - 0.5) * 200,
        (random.nextDouble() - 0.5) * 2,
      );

      final position = center + offset + jitter * (1 - density);

      particles.add(Particle(position));
    }

    return particles;
  }

  @override
  bool shouldRepaint(covariant DensityPainter oldDelegate) =>
      oldDelegate.density != density;
}
