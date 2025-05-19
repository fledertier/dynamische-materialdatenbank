import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// todo: join dimensions for flawless z-order
class DensityVisualization extends StatelessWidget {
  final double density;
  final EdgeInsets padding;
  final bool isThreeDimensional;

  const DensityVisualization({
    super.key,
    required this.density,
    this.padding = const EdgeInsets.all(16),
    this.isThreeDimensional = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            if (isThreeDimensional)
              CustomPaint(
                painter: DensityPainter(
                  density,
                  foregroundColor: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerLow,
                  isThreeDimensional: isThreeDimensional,
                  z: 0.5,
                  seed: -5,
                ),
              ),
            CustomPaint(
              painter: DensityPainter(
                density,
                foregroundColor: colorScheme.primary,
                backgroundColor: colorScheme.surfaceContainerLow,
                isThreeDimensional: isThreeDimensional,
                z: 0,
                seed: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DensityPainter extends CustomPainter {
  static const double minSpread = 0;
  static const double maxSpread = 400;

  static const double minRadius = 10.0;
  static const double maxRadius = 16.0;
  static const highlightPosition = Alignment(-0.2, -0.2);

  static const int gridSize = 3;

  const DensityPainter(
    this.density, {
    this.highlightColor = Colors.white,
    required this.foregroundColor,
    required this.backgroundColor,
    this.isThreeDimensional = false,
    this.z = 0,
    this.seed = 0,
  });

  final double density;
  final Color highlightColor;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool isThreeDimensional;
  final double z;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final particles = createParticles(size);

    int byDepth(Particle a, Particle b) => b.z.compareTo(a.z);
    particles.sort(byDepth);

    for (final particle in particles) {
      drawParticle(particle, canvas);
    }
  }

  void drawParticle(Particle particle, Canvas canvas) {
    final paint = createPaint(particle);
    canvas.drawCircle(Offset(particle.x, particle.y), particle.radius, paint);
  }

  Paint createPaint(Particle particle) {
    if (!isThreeDimensional) {
      final color = Color.lerp(foregroundColor, highlightColor, 0.4);
      return Paint()
        ..color = Color.lerp(backgroundColor, color, particle.alpha)!;
    }
    final gradient = RadialGradient(
      center: highlightPosition,
      colors: [
        Color.lerp(backgroundColor, highlightColor, particle.alpha)!,
        Color.lerp(backgroundColor, foregroundColor, particle.alpha)!,
      ],
    );
    final shader = gradient.createShader(
      Rect.fromCircle(center: particle.position, radius: particle.radius),
    );
    return Paint()..shader = shader;
  }

  List<Particle> createParticles(Size size) {
    final particles = <Particle>[];

    final random = Random(seed);

    final spread = lerpDouble(maxSpread, minSpread, density)!;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final t = pow(density, 1.5).clamp(0.0, 1.0).toDouble();

    final count = gridSize * gridSize;
    final cellWidth = size.width / gridSize;
    final cellHeight = size.height / gridSize;

    for (int i = 0; i < count; i++) {
      final gx = i % gridSize;
      final gy = i ~/ gridSize;

      final gridPos = Offset((gx + 0.5) * cellWidth, (gy + 0.5) * cellHeight);
      final center = this.z == 0 ? Alignment(0.2, 0.2) : Alignment(-0.2, -0.2);
      final centralFactor = Offset(
        gx - gridSize / 2 + center.x,
        gy - gridSize / 2 + center.y,
      );
      final positionOffset = Offset(
        centerX + (random.nextDouble() - 0.5) * spread * centralFactor.dx,
        centerY + (random.nextDouble() - 0.5) * spread * centralFactor.dy,
      );
      final zOffset = (random.nextDouble() - 0.5) * spread * 0.01;
      final z = lerpDouble(zOffset, this.z, t)!;
      final depthOffset = Offset(16, 16) * pow(z.abs(), 0.6).toDouble();
      final position =
          Offset.lerp(positionOffset, gridPos, t * 0.9)! + depthOffset;
      final radius =
          isThreeDimensional
              ? lerpDouble(lerpDouble(maxRadius, minRadius, z)!, maxRadius, t)!
              : maxRadius;
      final alpha =
          isThreeDimensional ? lerpDouble(1, 0.5, z)!.clamp(0.0, 1.0) : 1.0;

      particles.add(
        Particle(
          x: position.dx,
          y: position.dy,
          z: z,
          radius: radius,
          alpha: alpha,
        ),
      );
    }
    return particles;
  }

  @override
  bool shouldRepaint(covariant DensityPainter oldDelegate) =>
      oldDelegate.density != density;
}

class Particle {
  const Particle({
    required this.x,
    required this.y,
    required this.z,
    required this.radius,
    required this.alpha,
  });

  final double x, y, z, radius, alpha;

  Offset get position => Offset(x, y);
}
