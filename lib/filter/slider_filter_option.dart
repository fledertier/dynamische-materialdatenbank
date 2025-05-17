import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_provider.dart';
import 'filter_provider.dart';

class SliderFilterOption extends ConsumerWidget {
  const SliderFilterOption(this.attribute, {super.key});

  final String attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider);
    final optionsNotifier = ref.read(filterOptionsProvider.notifier);
    final extrema = ref.watch(attributeExtremaProvider(attribute)).value;
    final minWeight = extrema?.min ?? 0;
    final maxWeight = extrema?.max ?? 1;
    final weight = options[attribute]?.clamp(minWeight, maxWeight) ?? maxWeight;
    final attributeType =
        ref.watch(attributeProvider(attribute))?.type as NumberAttributeType?;
    final unitType = attributeType?.unitType;

    return Slider(
      label: '${weight.toStringAsFixed(1)} ${unitType?.base}',
      min: minWeight,
      max: maxWeight,
      value: weight,
      onChanged: (value) {
        optionsNotifier.updateWith({
          attribute: value != maxWeight ? value : null,
        });
      },
    );
  }
}
