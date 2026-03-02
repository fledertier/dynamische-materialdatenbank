import 'package:dynamische_materialdatenbank/features/attributes/custom/density/density_painter.dart';
import 'package:flutter/material.dart';

class DensityVisualization extends StatelessWidget {
  final double density;
  final bool isThreeDimensional;

  const DensityVisualization({
    super.key,
    required this.density,
    this.isThreeDimensional = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: DensityPainter(
              density,
              foregroundColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerLow,
              isThreeDimensional: isThreeDimensional,
              seed: 3,
            ),
          ),
        ],
      ),
    );
  }
}
