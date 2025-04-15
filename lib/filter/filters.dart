import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/attribute_provider.dart';
import '../providers/filter_provider.dart';
import 'labeled.dart';
import 'labeled_list.dart';
import 'side_sheet.dart';

class Filters extends ConsumerWidget {
  const Filters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(filterProvider);
    final optionsNotifier = ref.read(filterProvider.notifier);
    final attributes = ref.watch(attributesStreamProvider).value ?? {};

    return SideSheet.detached(
      title: Text('Filters'),
      topActions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.close), onPressed: () {}),
      ],
      bottomActions: [
        FilledButton(child: Text('Save'), onPressed: () {}),
        OutlinedButton(child: Text('Cancel'), onPressed: () {}),
      ],
      width: 280,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledList(
            label: Text('Nachhaltigkeit'),
            children: [
              CheckboxListTile(
                title: LoadingText(attributes[Attributes.recyclable]?.name),
                value: options[Attributes.recyclable] ?? false,
                onChanged: (value) {
                  optionsNotifier.updateWith({
                    Attributes.recyclable: value == true ? value : null,
                  });
                },
              ),
              CheckboxListTile(
                title: LoadingText(attributes[Attributes.biodegradable]?.name),
                value: options[Attributes.biodegradable] ?? false,
                onChanged: (value) {
                  optionsNotifier.updateWith({
                    Attributes.biodegradable: value == true ? value : null,
                  });
                },
              ),
              CheckboxListTile(
                title: LoadingText(attributes[Attributes.biobased]?.name),
                value: options[Attributes.biobased] ?? false,
                onChanged: (value) {
                  optionsNotifier.updateWith({
                    Attributes.biobased: value == true ? value : null,
                  });
                },
              ),
            ],
          ),
          Labeled(
            label: LoadingText(attributes[Attributes.manufacturer]?.name),
            child: Consumer(
              builder: (context, ref, child) {
                final values =
                    ref.watch(attributeValuesProvider(Attributes.manufacturer)).value;
                final manufacturers = values?.values.toSet().sortedBy(
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
                    ...?manufacturers?.map(
                      (manufacturer) => DropdownMenuEntry(
                        value: manufacturer,
                        label: manufacturer.toString(),
                      ),
                    ),
                  ],
                  initialSelection: options[Attributes.manufacturer],
                  onSelected: (value) {
                    optionsNotifier.updateWith({Attributes.manufacturer: value});
                  },
                );
              },
            ),
          ),
          Labeled(
            label: LoadingText(attributes[Attributes.weight]?.name),
            gap: 6,
            child: Consumer(
              builder: (context, ref, child) {
                final extrema =
                    ref.watch(attributeExtremaProvider(Attributes.weight)).value;
                final minWeight = extrema?.min ?? 0;
                final maxWeight = extrema?.max ?? 1;
                final weight =
                    options[Attributes.weight]?.clamp(minWeight, maxWeight) ?? maxWeight;
                return Slider(
                  label: '${weight.toStringAsFixed(1)} Kg',
                  min: minWeight,
                  max: maxWeight,
                  value: weight,
                  onChanged: (value) {
                    optionsNotifier.updateWith({
                      Attributes.weight: value != maxWeight ? value : null,
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
