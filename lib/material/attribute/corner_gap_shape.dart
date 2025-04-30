import 'package:flutter/material.dart';

enum CornerPosition { topLeft, topRight, bottomLeft, bottomRight }

class CornerGapShape extends StatelessWidget {
  final double size;
  final double radius;
  final Color color;
  final CornerPosition position;

  const CornerGapShape({
    super.key,
    required this.size,
    required this.radius,
    required this.position,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final turns = switch (position) {
      CornerPosition.topLeft => 0,
      CornerPosition.topRight => 1,
      CornerPosition.bottomRight => 2,
      CornerPosition.bottomLeft => 3,
    };

    return RotatedBox(
      quarterTurns: turns,
      child: CustomPaint(
        size: Size(size, size),
        painter: _SingleCornerPainter(
          radius: radius.clamp(0.0, size),
          color: color,
        ),
      ),
    );
  }
}

class _SingleCornerPainter extends CustomPainter {
  final double radius;
  final Color color;

  _SingleCornerPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final effectiveRadius = radius.clamp(0.0, size.width);

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(effectiveRadius, 0)
          ..arcTo(
            Rect.fromCircle(
              center: Offset(effectiveRadius, effectiveRadius),
              radius: effectiveRadius,
            ),
            -3.14 / 2,
            -3.14 / 2,
            false,
          )
          ..lineTo(0, effectiveRadius)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SingleCornerPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
