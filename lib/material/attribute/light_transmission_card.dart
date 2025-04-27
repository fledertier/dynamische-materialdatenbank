import 'package:flutter/material.dart';

import 'ray_painter.dart';

class LightTransmissionCard extends StatelessWidget {
  const LightTransmissionCard({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final transmittedRays = (value * 10).round();
    final nonTransmittedRays = 10 - transmittedRays;

    return Container(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                'Light transmission',
                style: TextTheme.of(context).labelMedium,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Text(
                    (value * 100).toStringAsFixed(0),
                    style: TextTheme.of(
                      context,
                    ).titleLarge?.copyWith(fontFamily: 'Lexend'),
                  ),
                  Text(
                    '%',
                    style: TextTheme.of(context).bodyMedium?.copyWith(
                      color: ColorScheme.of(context).onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox.square(
            dimension: 126,
            child: CustomPaint(
              painter: RayPainter(
                rays: [
                  for (int i = 0; i < nonTransmittedRays; i++) Ray.incident,
                  for (int i = 0; i < transmittedRays; i++) Ray.transmitted,
                ],
                rayColor: ColorScheme.of(context).onPrimaryContainer,
                mediumColor: ColorScheme.of(context).primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
