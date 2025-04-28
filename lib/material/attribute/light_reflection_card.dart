import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ray_painter.dart';

class LightReflectionCard extends ConsumerWidget {
  const LightReflectionCard({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.lightReflection));
    final reflectedRays = (value * 10).round();
    final nonReflectedRays = 10 - reflectedRays;

    return AttributeCard(
      label: LoadingText(attribute?.name),
      value: Text((value * 100).toStringAsFixed(0)),
      unit: Text('%'),
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: RayPainter(
            rays: [
              for (int i = 0; i < nonReflectedRays; i++) Ray.incident,
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
