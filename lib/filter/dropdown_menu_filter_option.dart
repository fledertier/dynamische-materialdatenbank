import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/filter/filter_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManufacturerDropdownMenuFilterOption extends ConsumerWidget {
  const ManufacturerDropdownMenuFilterOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterOptions = ref.watch(filterOptionsProvider);
    final selectedOption =
        filterOptions[Attributes.manufacturer] as TranslatableText?;
    final values = ref
        .watch(valuesProvider(Attributes.manufacturer))
        .valueOrNull;
    final manufacturers = values?.values ?? [];

    return DropdownMenu<String?>(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(16),
      ),
      enableFilter: true,
      expandedInsets: EdgeInsets.zero,
      menuHeight: 16 + 48 * 6,
      dropdownMenuEntries: [
        DropdownMenuEntry(value: null, label: 'Alle'),
        for (final name in sortedNames(manufacturers))
          DropdownMenuEntry(value: name, label: name),
      ],
      initialSelection: selectedOption?.valueDe,
      onSelected: (manufacturer) {
        final optionsNotifier = ref.read(filterOptionsProvider.notifier);
        optionsNotifier.updateWith({
          Attributes.manufacturer: manufacturer != null
              ? TranslatableText.fromValue(manufacturer)
              : null,
        });
      },
    );
  }

  List<String> sortedNames(Iterable<dynamic> manufacturers) {
    return manufacturers
        .map((manufacturer) {
          final name =
              manufacturer[Attributes.manufacturerName] as TranslatableText;
          return name.value;
        })
        .toSet()
        .sorted();
  }
}
