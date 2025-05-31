import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'filter_provider.dart';

class ManufacturerDropdownMenuFilterOption extends ConsumerWidget {
  const ManufacturerDropdownMenuFilterOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterOptionsProvider);
    final optionsNotifier = ref.read(filterOptionsProvider.notifier);
    final values = ref.watch(valuesProvider(Attributes.manufacturer)).value;
    final manufacturers = values?.values.toSet().sortedBy((manufacturer) {
      return (manufacturer[Attributes.manufacturerName] as TranslatableText)
          .value;
    });
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
        for (final manufacturer in manufacturers ?? [])
          DropdownMenuEntry(
            value: manufacturer,
            label:
                (manufacturer[Attributes.manufacturerName] as TranslatableText)
                    .value,
          ),
      ],
      initialSelection: options[Attributes.manufacturer],
      onSelected: (manufacturer) {
        optionsNotifier.updateWith({Attributes.manufacturer: manufacturer});
      },
    );
  }
}
