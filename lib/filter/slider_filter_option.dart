import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/filter/filter_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliderFilterOption extends ConsumerWidget {
  const SliderFilterOption(this.attributeId, {super.key});

  final String attributeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider);
    final optionsNotifier = ref.read(filterOptionsProvider.notifier);
    final extrema = ref.watch(valuesExtremaProvider(attributeId)).value;
    final minValue = extrema?.min ?? 0;
    final maxValue = extrema?.max ?? 1;
    final value = options[attributeId]?.clamp(minValue, maxValue) ?? maxValue;
    final attributeType =
        ref.watch(attributeProvider(AttributePath(attributeId))).value?.type
            as NumberAttributeType?;
    final unitType = attributeType?.unitType;

    return Slider(
      label: '${value.toStringAsFixed(1)} ${unitType?.base}',
      min: minValue.toDouble(),
      max: maxValue.toDouble(),
      value: value,
      onChanged: (value) {
        optionsNotifier.updateWith({
          attributeId: value != maxValue ? value : null,
        });
      },
    );
  }
}
