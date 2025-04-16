import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attribute_provider.dart';
import '../providers/filter_provider.dart';

class DropdownMenuFilterOption extends ConsumerWidget {
  const DropdownMenuFilterOption(this.attribute, {super.key});

  final String attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterProvider);
    final optionsNotifier = ref.read(filterProvider.notifier);
    final values = ref.watch(attributeValuesProvider(attribute)).value;
    final suggestions = values?.values.toSet().sortedBy(
      (value) => value.toString(),
    );
    return DropdownMenu(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.all(16),
      ),
      enableFilter: true,
      expandedInsets: EdgeInsets.zero,
      menuHeight: 16 + 48 * 4,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: null, label: 'Alle'),
        ...?suggestions?.map(
          (suggestion) => DropdownMenuEntry(
            value: suggestion,
            label: suggestion.toString(),
          ),
        ),
      ],
      initialSelection: options[attribute],
      onSelected: (value) {
        optionsNotifier.updateWith({attribute: value});
      },
    );
  }
}
