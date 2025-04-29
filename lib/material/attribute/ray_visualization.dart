import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class RayVisualization extends StatelessWidget {
  const RayVisualization({
    super.key,
    this.incidentRays = 0,
    this.reflectedRays = 0,
    this.absorbedRays = 0,
    this.transmittedRays = 0,
  });

  final num incidentRays;
  final num reflectedRays;
  final num absorbedRays;
  final num transmittedRays;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _RayPainter(
          rays: [
            for (int i = 0; i < incidentRays; i++) Ray.incident,
            for (int i = 0; i < transmittedRays; i++) Ray.transmitted,
            for (int i = 0; i < absorbedRays; i++) Ray.absorbed,
            for (int i = 0; i < reflectedRays; i++) Ray.reflected,
          ],
          spacing: 8,
          mediumWidth: 30,
          rayColor: ColorScheme.of(context).onPrimaryContainer,
          mediumColor: ColorScheme.of(context).primaryContainer,
        ),
      ),
    );
  }
}

enum Ray { incident, reflected, absorbed, transmitted }

class _RayPainter extends CustomPainter {
  _RayPainter({
    required this.rays,
    required this.spacing,
    required this.mediumWidth,
    required this.rayColor,
    required this.mediumColor,
  });

  final List<Ray> rays;
  final double spacing;
  final double mediumWidth;
  final Color rayColor;
  final Color mediumColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = mediumColor
          ..strokeWidth = 1.5;

    final medium = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: mediumWidth,
      height: size.height,
    );
    canvas.drawRect(medium, paint);

    paint.color = rayColor;
    final gradient = Offset(1, 1 - (rays.length - 1) * spacing / size.height);
    rays.forEachIndexed((i, ray) {
      final start = Offset(0, i * spacing);
      final end = start + gradient * length(ray, size.width);

      if (showHead(ray)) {
        canvas.drawArrow(start, end, paint);
      } else {
        canvas.drawLine(start, end, paint);
      }
      if (reflect(ray)) {
        final endReflection = end + (end - start).scale(-1, 1);
        canvas.drawArrow(end, endReflection, paint);
      }
    });
  }

  double length(Ray ray, double width) {
    return switch (ray) {
      Ray.incident || Ray.reflected => (width - mediumWidth) / 2,
      Ray.absorbed => width / 2,
      Ray.transmitted => width,
    };
  }

  bool showHead(Ray ray) {
    return ray == Ray.absorbed || ray == Ray.transmitted;
  }

  bool reflect(Ray ray) {
    return ray == Ray.reflected;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _RayPainter) {
      return true;
    }
    return oldDelegate.rays != rays ||
        oldDelegate.spacing != spacing ||
        oldDelegate.mediumWidth != mediumWidth;
  }
}

extension on Canvas {
  void drawArrow(Offset start, Offset end, Paint paint) {
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    final headAngle = pi / 6;
    final headSize = paint.strokeWidth * 5;
    final headRight = Offset(cos(angle - headAngle), sin(angle - headAngle));
    final headLeft = Offset(cos(angle + headAngle), sin(angle + headAngle));

    drawLine(start, end, paint);
    drawLine(end - headRight * headSize, end, paint);
    drawLine(end - headLeft * headSize, end, paint);
  }
}
