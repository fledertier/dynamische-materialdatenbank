import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attribute_provider.dart';
import 'filter_provider.dart';

class CheckboxFilterOption extends ConsumerWidget {
  const CheckboxFilterOption(this.attribute, {super.key});

  final String attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider);
    final optionsNotifier = ref.read(filterOptionsProvider.notifier);
    final attributes = ref.watch(attributesStreamProvider).value ?? {};

    return CheckboxListTile(
      title: LoadingText(attributes[attribute]?.name),
      value: options[attribute] ?? false,
      onChanged: (value) {
        optionsNotifier.updateWith({attribute: value == true ? value : null});
      },
    );
  }
}
