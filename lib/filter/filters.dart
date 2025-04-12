import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final notifier = ref.read(filterProvider.notifier);

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
                title: Text('Recyclebar'),
                value: options.recyclable ?? false,
                onChanged: (value) {
                  notifier.options = options.copyWithNullable(
                    recyclable: () => value == true ? value : null,
                  );
                },
              ),
              CheckboxListTile(
                title: Text('Abbaubar'),
                value: options.biodegradable ?? false,
                onChanged: (value) {
                  notifier.options = options.copyWithNullable(
                    biodegradable: () => value == true ? value : null,
                  );
                },
              ),
              CheckboxListTile(
                title: Text('Biobasiert'),
                value: options.biobased ?? false,
                onChanged: (value) {
                  notifier.options = options.copyWithNullable(
                    biobased: () => value == true ? value : null,
                  );
                },
              ),
            ],
          ),
          Labeled(
            label: Text('Hersteller'),
            child: DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                contentPadding: EdgeInsets.all(16),
              ),
              enableFilter: true,
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: null, label: 'Alle'),
                DropdownMenuEntry(
                  value: 'Manufacturer 1',
                  label: 'Manufacturer 1',
                ),
                DropdownMenuEntry(
                  value: 'Manufacturer 2',
                  label: 'Manufacturer 2',
                ),
              ],
              initialSelection: options.manufacturer,
              onSelected: (value) {
                notifier.options = options.copyWithNullable(
                  manufacturer: () => value,
                );
              },
            ),
          ),
          Labeled(
            label: Text('Gewicht'),
            gap: 6,
            child: Consumer(
              builder: (context, ref, child) {
                final extrema =
                    ref.watch(attributeExtremaProvider('weight')).value;
                final minWeight = extrema?.min ?? 0;
                final maxWeight = extrema?.max ?? 1;
                final weight =
                    options.weight?.clamp(minWeight, maxWeight) ?? maxWeight;
                return Slider(
                  label: '${weight.toStringAsFixed(1)} Kg',
                  min: minWeight,
                  max: maxWeight,
                  value: weight,
                  onChanged: (value) {
                    notifier.options = options.copyWithNullable(
                      weight: () => value != maxWeight ? value : null,
                    );
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
