import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'subjective_impression.dart';

class SubjectiveImpressionBalls extends StatefulWidget {
  SubjectiveImpressionBalls({
    super.key,
    required this.width,
    this.padding = const EdgeInsets.fromLTRB(-12, 0, -12, -12),
    this.spacing = 4,
    required this.impressions,
    required this.onUpdate,
    this.edit = false,
  }) : height = calculateHeight(impressions, width);

  final double width;
  final double height;
  final EdgeInsets padding;
  final double spacing;
  final List<SubjectiveImpression> impressions;
  final void Function(SubjectiveImpression? impression) onUpdate;
  final bool edit;

  final double gravity = 0.3;
  final double airResistance = 0.01;
  final double timeStep = 0.1;

  static double calculateHeight(
    List<SubjectiveImpression> impressions,
    double width,
  ) {
    final areas = impressions.map(
      (impression) => Size.fromRadius(radiusOf(impression)).area,
    );
    return areas.sum / width;
  }

  @override
  State<SubjectiveImpressionBalls> createState() =>
      _SubjectiveImpressionBallsState();
}

class _SubjectiveImpressionBallsState extends State<SubjectiveImpressionBalls>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final List<Ball> balls;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.repeat();

    final random = Random(
      Object.hashAllUnordered(
        widget.impressions.map((impression) => impression.name),
      ),
    );
    balls = [
      for (final impression in widget.impressions)
        Ball.impression(
          position: Vector2(
            random.nextDouble() * widget.width,
            random.nextDouble() * widget.height,
          ),
          velocity: Vector2.zero(),
          rotation: random.nextDouble() * radians(40) - radians(20),
          impression: impression,
        ),
      if (widget.edit)
        Ball.add(
          position: Vector2(widget.width / 2, 0),
          velocity: Vector2.zero(),
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
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final ball in balls)
            Positioned.fromRect(
              rect: Rect.fromCircle(
                center: Offset(ball.position.x, ball.position.y),
                radius: ball.radius,
              ),
              child: SubjectiveImpressionButton(
                ball: ball,
                onUpdate: widget.onUpdate,
                edit: widget.edit,
              ),
            ),
        ],
      ),
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

class SubjectiveImpressionButton extends StatelessWidget {
  const SubjectiveImpressionButton({
    super.key,
    required this.ball,
    required this.onUpdate,
    this.edit = false,
  });

  final Ball ball;
  final void Function(SubjectiveImpression? impression) onUpdate;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    if (ball.impression == null) {
      return IconButton.outlined(
        constraints: BoxConstraints.tight(Size.fromRadius(ball.radius)),
        icon: Icon(Icons.add, size: 18),
        onPressed: () => onUpdate(null),
      );
    }
    return FilledButton(
      style: FilledButton.styleFrom(
        foregroundColor: Colors.black,
        disabledForegroundColor: Colors.black,
        backgroundColor: ball.color,
        disabledBackgroundColor: ball.color,
        fixedSize: Size.fromRadius(ball.radius),
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
      onPressed: edit ? () => onUpdate(ball.impression) : null,
      child: Transform.rotate(
        angle: ball.rotation,
        child: Text(
          ball.label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: sqrt(ball.radius * 3.6)),
        ),
      ),
    );
  }
}

class Ball {
  Ball.impression({
    required this.position,
    required this.velocity,
    required this.rotation,
    required SubjectiveImpression this.impression,
  }) : radius = radiusOf(impression),
       color = colorOf(impression),
       label = impression.name;

  Ball.add({required this.position, required this.velocity})
    : rotation = 0,
      radius = 40,
      color = Colors.transparent,
      label = '';

  Vector2 position;
  Vector2 velocity;
  double rotation;
  double radius;
  Color color;
  String label;
  SubjectiveImpression? impression;
}
