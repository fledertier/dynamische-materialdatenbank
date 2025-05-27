import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_provider.dart';
import 'filter_provider.dart';

class ManufacturerDropdownMenuFilterOption extends ConsumerWidget {
  const ManufacturerDropdownMenuFilterOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider);
    final optionsNotifier = ref.read(filterOptionsProvider.notifier);
    final manufacturers =
        ref.watch(valuesProvider(Attributes.manufacturer)).value;
    final suggestions = manufacturers?.values.toSet().sortedBy(
      (manufacturer) => manufacturer[Attributes.manufacturerName] as String,
    );
    return DropdownMenu(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: UnderlineInputBorder(),
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
            label: suggestion[Attributes.manufacturerName],
          ),
        ),
      ],
      initialSelection: options[Attributes.manufacturer],
      onSelected: (manufacturer) {
        optionsNotifier.updateWith({Attributes.manufacturer: manufacturer});
      },
    );
  }
}
