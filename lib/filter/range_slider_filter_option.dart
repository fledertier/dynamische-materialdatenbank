import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/filter/filter_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RangeSliderFilterOption extends ConsumerWidget {
  const RangeSliderFilterOption(this.attributeId, {super.key});

  final String attributeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extrema = ref.watch(valuesExtremaProvider(attributeId)).valueOrNull;
    final minValue = extrema?.min ?? 0;
    final maxValue = extrema?.max ?? 1;

    final values = ref.watch(filterOptionsProvider)[attributeId];
    final startValue = values?.start?.clamp(minValue, maxValue) ?? minValue;
    final endValue = values?.end?.clamp(minValue, maxValue) ?? maxValue;

    final attributeType = ref
        .watch(attributeProvider(AttributePath(attributeId)))
        .valueOrNull
        ?.type;
    final unit = (attributeType as NumberAttributeType?)?.unitType?.base;

    return RangeSlider(
      labels: RangeLabels(
        '${startValue.toStringAsFixed(1)} $unit',
        '${endValue.toStringAsFixed(1)} $unit',
      ),
      min: minValue.toDouble(),
      max: maxValue.toDouble(),
      values: RangeValues(startValue, endValue),
      onChanged: (values) {
        ref.read(filterOptionsProvider.notifier).updateWith({
          attributeId: (
            start: values.start != minValue ? values.start : null,
            end: values.end != maxValue ? values.end : null,
          ),
        });
      },
    );
  }
}
