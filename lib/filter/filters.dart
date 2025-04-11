import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attribute_provider.dart';
import 'filter_state.dart';
import 'labeled.dart';
import 'labeled_list.dart';
import 'side_sheet.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  FilterState state = FilterState();

  @override
  Widget build(BuildContext context) {
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
                value: state.recyclable ?? false,
                onChanged: (value) {
                  setState(() {
                    if (value == false) value = null;
                    state.recyclable = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Abbaubar'),
                value: state.biodegradable ?? false,
                onChanged: (value) {
                  setState(() {
                    if (value == false) value = null;
                    state.biodegradable = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Biobasiert'),
                value: state.biobased ?? false,
                onChanged: (value) {
                  setState(() {
                    if (value == false) value = null;
                    state.biobased = value;
                  });
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
              initialSelection: state.manufacturer,
              onSelected: (value) {
                setState(() {
                  state.manufacturer = value;
                });
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
                    state.weight?.clamp(minWeight, maxWeight) ?? maxWeight;
                return Slider(
                  label: '${weight.toStringAsFixed(1)} Kg',
                  min: minWeight,
                  max: maxWeight,
                  value: weight,
                  onChanged: (value) {
                    setState(() {
                      if (value != maxWeight) {
                        state.weight = value;
                      } else {
                        state.weight = null;
                      }
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
