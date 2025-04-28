import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ray_painter.dart';

class UValueCard extends ConsumerWidget {
  const UValueCard({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.uValue));
    final transmittedRays = (value / 6 * 10).clamp(0, 10).round();
    final reflectedRays = 10 - transmittedRays;

    return AttributeCard(
      label: LoadingText(attribute?.name),
      value: Text(value.toStringAsFixed(1)),
      unit: Text('W/m²K'),
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: RayPainter(
            rays: [
              for (int i = 0; i < transmittedRays; i++) Ray.transmitted,
              for (int i = 0; i < reflectedRays; i++) Ray.reflected,
            ],
            rayColor: ColorScheme.of(context).onPrimaryContainer,
            mediumColor: ColorScheme.of(context).primaryContainer,
          ),
        ),
      ),
    );
  }
}
