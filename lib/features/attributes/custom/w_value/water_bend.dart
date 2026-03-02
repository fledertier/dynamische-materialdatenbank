import 'package:dynamische_materialdatenbank/core/theme/theme.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/w_value/corner_gap_shape.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/w_value/water_absorption_visualization.dart';
import 'package:flutter/material.dart';

enum WaterSide { left, right }

class WaterBend extends StatelessWidget {
  static const double inwards = -1;
  static const double even = 0;
  static const double outwards = 1;

  const WaterBend(
    this.bend, {
    super.key,
    required this.side,
    this.size = 16,
    this.waterLevel = 16,
  });

  final WaterSide side;
  final double bend;
  final double size;
  final double waterLevel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final backgroundColor = colorScheme.surfaceContainerLow;
    final effectiveSize = bend.abs() * size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (bend > 0)
          Padding(
            padding: EdgeInsets.only(bottom: waterLevel),
            child: CornerGapShape(
              size: effectiveSize,
              radius: effectiveSize,
              position: side == WaterSide.right
                  ? CornerPosition.bottomLeft
                  : CornerPosition.bottomRight,
              color: colorScheme.water,
            ),
          ),
        if (bend < 0)
          Padding(
            padding: EdgeInsets.only(bottom: waterLevel - effectiveSize),
            child: CornerGapShape(
              size: effectiveSize,
              radius: effectiveSize,
              position: side == WaterSide.right
                  ? CornerPosition.topLeft
                  : CornerPosition.topRight,
              color: backgroundColor,
            ),
          ),
      ],
    );
  }
}

class BoxInWater extends StatelessWidget {
  const BoxInWater({
    super.key,
    this.icon,
    this.waterLevel = 0,
    this.borderRadius = 8,
    this.size = 70,
  });

  final Widget? icon;
  final double waterLevel;
  final double borderRadius;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: DecoratedBox(
          decoration: BoxDecoration(color: colorScheme.primaryFixedDim),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: waterLevel,
                child: ColoredBox(
                  color: plusDarker(
                    colorScheme.water,
                    wetMaterialColor,
                  ).withValues(alpha: 0.4),
                ),
              ),
              IconTheme(
                data: IconThemeData(
                  size: 32,
                  color: colorScheme.onPrimaryFixed,
                ),
                child: Center(child: icon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color plusDarker(Color color1, Color color2) {
  double blendChannel(double c1, double c2) {
    return (c1 + c2 - 1).clamp(0, 1);
  }

  return Color.from(
    alpha: 1,
    red: blendChannel(color1.r, color2.r),
    green: blendChannel(color1.g, color2.g),
    blue: blendChannel(color1.b, color2.b),
  );
}
