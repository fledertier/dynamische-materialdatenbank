import 'package:dynamische_materialdatenbank/core/theme/theme.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/w_value/water_bend.dart';
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

extension on double {
  double map({required List<double> from, required List<double> to}) {
    final clampedValue = clamp(from[0], from[1]);
    return ((clampedValue - from[0]) / (from[1] - from[0])) * (to[1] - to[0]) +
        to[0];
  }
}
