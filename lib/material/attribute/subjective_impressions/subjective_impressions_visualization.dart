import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

import 'subjective_impression.dart';

final _colors = [
  Color(0xFFA6ACDC),
  Color(0xFF7DA4DB),
  Color(0xFF8E9867),
  Color(0xFFE1927F),
  Color(0xFFEEDBD1),
  Color(0xFFF3DE8A),
];

class SubjectiveImpressionsVisualization extends StatefulWidget {
  const SubjectiveImpressionsVisualization({
    super.key,
    required this.width,
    required this.height,
    this.padding = const EdgeInsets.all(-12),
    this.spacing = 4,
    required this.impressions,
  });

  final double width;
  final double height;
  final EdgeInsets padding;
  final double spacing;
  final List<SubjectiveImpression> impressions;

  final double gravity = 0.3;
  final double airResistance = 0.01;
  final double timeStep = 0.1;

  @override
  State<SubjectiveImpressionsVisualization> createState() =>
      _SubjectiveImpressionsVisualizationState();
}

class _SubjectiveImpressionsVisualizationState
    extends State<SubjectiveImpressionsVisualization>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final List<_Ball> balls;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();

    final random = Random(
      Object.hashAllUnordered(
        widget.impressions.map((impression) => impression.name),
      ),
    );
    balls = [
      for (final impression in widget.impressions)
        _Ball(
          position: Vector2(
            random.nextDouble() * widget.width,
            random.nextDouble() * widget.height,
          ),
          velocity: Vector2.zero(),
          rotation: random.nextDouble() * radians(40) - radians(20),
          radius: impression.count * 10 + 20,
          color: _colors[random.nextInt(_colors.length)],
          label: impression.name,
        ),
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    update();
    return CustomPaint(
      painter: _BallPainter(balls),
      size: Size(widget.width, widget.height),
    );
  }

  void update() {
    for (int i = 0; i < 10; i++) {
      applyPhysics();
      handleWallCollisions();
      handleCollisions();
    }
  }

  void applyPhysics() {
    for (final ball in balls) {
      ball.velocity *= (1 - widget.airResistance);
      ball.velocity.y += widget.gravity;
      ball.position += ball.velocity * widget.timeStep;
    }
  }

  void handleWallCollisions() {
    for (final ball in balls) {
      ball.position.x = ball.position.x.clamp(
        ball.radius + widget.padding.left,
        widget.width - ball.radius - widget.padding.right,
      );
      ball.position.y = ball.position.y.clamp(
        ball.radius + widget.padding.top,
        widget.height - ball.radius - widget.padding.bottom,
      );
    }
  }

  void handleCollisions() {
    for (int i = 0; i < balls.length - 1; i++) {
      for (int j = i + 1; j < balls.length; j++) {
        final ballA = balls[i];
        final ballB = balls[j];

        final delta = ballA.position - ballB.position;
        final distance = delta.length;
        final minDistance = ballA.radius + ballB.radius + widget.spacing;

        if (distance < minDistance && distance != 0) {
          final normal = delta.normalized();
          final relativeVelocity = ballA.velocity - ballB.velocity;
          final velocityAlongNormal = relativeVelocity.dot(normal);

          final impulse = normal * -velocityAlongNormal;
          ballA.velocity += impulse;
          ballB.velocity -= impulse;

          final correction = normal * ((minDistance - distance) / 2);
          ballA.position += correction;
          ballB.position -= correction;
        }
      }
    }
  }
}

class _BallPainter extends CustomPainter {
  const _BallPainter(this.balls);

  final List<_Ball> balls;

  @override
  void paint(Canvas canvas, Size size) {
    for (final ball in balls) {
      drawBackground(ball, canvas);
      drawLabel(ball, canvas);
    }
  }

  void drawBackground(_Ball ball, Canvas canvas) {
    final paint = Paint()..color = ball.color;
    final offset = Offset(ball.position.x, ball.position.y);

    canvas.drawCircle(offset, ball.radius, paint);
  }

  void drawLabel(_Ball ball, Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: ball.label,
        style: TextStyle(fontSize: sqrt(ball.radius) * 2),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: (ball.radius - 16) * 2);

    final offset = Offset(
      ball.position.x - textPainter.width / 2,
      ball.position.y - textPainter.height / 2,
    );

    drawRotatedText(canvas, offset, ball.rotation, textPainter);
  }

  void drawRotatedText(
    Canvas canvas,
    Offset offset,
    double radians,
    TextPainter textPainter,
  ) {
    canvas.save();
    final pivot = textPainter.size.center(offset);
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(radians);
    canvas.translate(-pivot.dx, -pivot.dy);
    textPainter.paint(canvas, offset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Ball {
  _Ball({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.radius,
    required this.color,
    required this.label,
  });

  Vector2 position;
  Vector2 velocity;
  double rotation;
  double radius;
  Color color;
  String label;
}
