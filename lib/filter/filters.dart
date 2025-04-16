import 'package:dynamische_materialdatenbank/filter/slider_filter_option.dart';
import 'package:dynamische_materialdatenbank/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../providers/attribute_provider.dart';
import 'checkbox_filter_option.dart';
import 'dropdown_menu_filter_option.dart';
import 'labeled.dart';
import 'labeled_list.dart';
import 'side_sheet.dart';

class Filters extends ConsumerWidget {
  const Filters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              CheckboxFilterOption(Attributes.recyclable),
              CheckboxFilterOption(Attributes.biodegradable),
              CheckboxFilterOption(Attributes.biobased),
            ],
          ),
          Labeled(
            label: LoadingText(attributes[Attributes.manufacturer]?.name),
            child: DropdownMenuFilterOption(Attributes.manufacturer),
          ),
          Labeled(
            label: LoadingText(attributes[Attributes.weight]?.name),
            gap: 6,
            child: SliderFilterOption(Attributes.weight),
          ),
        ],
      ),
    );
  }
}
