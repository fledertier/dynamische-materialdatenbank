import 'dart:math';

import 'package:flutter/material.dart';

enum Ray { incident, reflected, absorbed, transmitted }

class RayPainter extends CustomPainter {
  RayPainter({
    required this.rays,
    this.spacing = 8,
    this.mediumWidth = 30,
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

    final material = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: mediumWidth,
      height: size.height,
    );
    canvas.drawRect(material, paint);

    paint.color = rayColor;
    final gradient = Offset(1, 1 - (rays.length - 1) * spacing / size.height);
    for (int i = 0; i < rays.length; i++) {
      final ray = rays[i];
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
    }
  }

  double length(Ray ray, double width) {
    return switch (ray) {
      Ray.incident || Ray.reflected => (width - mediumWidth) / 2,
      Ray.absorbed => width / 2,
      Ray.transmitted => width,
    };
  }

  bool showHead(Ray ray) {
    return ray != Ray.incident && ray != Ray.reflected;
  }

  bool reflect(Ray ray) {
    return ray == Ray.reflected;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is RayPainter) {
      return oldDelegate.rays != rays ||
          oldDelegate.spacing != spacing ||
          oldDelegate.mediumWidth != mediumWidth;
    }
    return true;
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
