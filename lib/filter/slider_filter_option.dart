import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/filter/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliderFilterOption extends ConsumerWidget {
  const SliderFilterOption(this.attribute, {super.key});

  final String attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider);
    final optionsNotifier = ref.read(filterOptionsProvider.notifier);
    final extrema = ref.watch(valuesExtremaProvider(attribute)).value;
    final minValue = extrema?.min ?? 0;
    final maxValue = extrema?.max ?? 1;
    final value = options[attribute]?.clamp(minValue, maxValue) ?? maxValue;
    final attributeType =
        ref.watch(attributeProvider(attribute)).value?.type
            as NumberAttributeType?;
    final unitType = attributeType?.unitType;

    return Slider(
      label: '${value.toStringAsFixed(1)} ${unitType?.base}',
      min: minValue.toDouble(),
      max: maxValue.toDouble(),
      value: value,
      onChanged: (value) {
        optionsNotifier.updateWith({
          attribute: value != maxValue ? value : null,
        });
      },
    );
  }
}
