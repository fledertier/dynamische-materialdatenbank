import 'package:dynamische_materialdatenbank/app/theme.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/w_value/corner_gap_shape.dart';
import 'package:flutter/material.dart';

abstract class WaterAbsorption {
  /// wasserundurchlässig: w <= 0.001
  static const double waterproof = 0.001;

  /// wasserabweisend: w <= 0.5
  static const double repellent = 0.5;

  /// wasserhemmend: w <= 2
  static const double resistant = 2.0;

  /// wassersaugend: w > 2
  static const double absorbent = 4;
}

const wetMaterialColor = Color(0xff6e97d9);

class WaterAbsorptionVisualization extends StatelessWidget {
  const WaterAbsorptionVisualization({super.key, required this.value});

  final double value;

  static const double boxBordeRadius = 8;
  static const double waterHeight = 16;
  static const double additionalWaterHeight = 50;

  static const halfPixel = Offset(0, 0.5);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final bend = waterBend();

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: waterHeight + additionalWaterHeight,
          child: ColoredBox(color: colorScheme.water),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: bend > 0 ? halfPixel : Offset.zero,
                  child: WaterBend(bend, side: WaterSide.left),
                ),
                Transform.translate(
                  offset: Offset(0, boxBordeRadius),
                  child: BoxInWater(waterLevel: waterLevel(bend), icon: icon()),
                ),
                Transform.translate(
                  offset: bend > 0 ? halfPixel : Offset.zero,
                  child: WaterBend(bend, side: WaterSide.right),
                ),
              ],
            ),
            SizedBox(
              height: additionalWaterHeight,
              child: DefaultTextStyle.merge(
                style: TextStyle(color: colorScheme.onWater),
                child: Center(child: label()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Icon? icon() {
    if (value < WaterAbsorption.waterproof) {
      return Icon(Icons.verified_user_outlined);
    } else if (value < WaterAbsorption.repellent) {
      return Icon(Icons.arrow_downward);
    } else if (value < WaterAbsorption.resistant) {
      return null;
    }
    return Icon(Icons.arrow_upward);
  }

  double waterBend() {
    if (value <= WaterAbsorption.repellent) {
      return value.map(
        from: [WaterAbsorption.waterproof, WaterAbsorption.repellent],
        to: [WaterBend.inwards, WaterBend.even],
      );
    } else if (value <= WaterAbsorption.absorbent) {
      return value.map(
        from: [WaterAbsorption.repellent, WaterAbsorption.absorbent],
        to: [WaterBend.even, WaterBend.outwards],
      );
    }
    return value.map(
      from: [WaterAbsorption.repellent, 100],
      to: [WaterBend.outwards, WaterBend.outwards * 2],
    );
  }

  double waterLevel(double bend) {
    final offset = value.map(
      from: [WaterAbsorption.waterproof, WaterAbsorption.repellent],
      to: [0, boxBordeRadius],
    );
    return waterHeight + bend * 16 + offset;
  }

  Text label() {
    if (value < WaterAbsorption.waterproof) {
      return Text('wasserdicht');
    } else if (value < WaterAbsorption.repellent) {
      return Text('wasserabweisend');
    } else if (value < WaterAbsorption.resistant) {
      return Text('wasserhemmend');
    }
    return Text('wassersaugend');
  }
}

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

extension on double {
  double map({required List<double> from, required List<double> to}) {
    final clampedValue = clamp(from[0], from[1]);
    return ((clampedValue - from[0]) / (from[1] - from[0])) * (to[1] - to[0]) +
        to[0];
  }
}
