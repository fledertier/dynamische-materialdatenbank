import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/filter/filter_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/boolean/boolean.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckboxFilterOption extends ConsumerWidget {
  const CheckboxFilterOption(this.attributeId, {super.key});

  final String attributeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider);
    final optionsNotifier = ref.read(filterOptionsProvider.notifier);
    final attribute =
        ref.watch(attributeProvider(AttributePath(attributeId))).value;

    final value = options[attributeId] as Boolean?;

    return CheckboxListTile(
      title: LoadingText(attribute?.name),
      value: value?.value ?? false,
      onChanged: (value) {
        optionsNotifier.updateWith({
          attributeId: value == true ? Boolean(value: true) : null,
        });
      },
    );
  }
}
