import 'package:dynamische_materialdatenbank/filter/slider_filter_option.dart';
import 'package:dynamische_materialdatenbank/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../advanced_search/advanced_search.dart';
import '../constants.dart';
import '../providers/attribute_provider.dart';
import '../query/query_source_provider.dart';
import 'checkbox_filter_option.dart';
import 'dropdown_menu_filter_option.dart';
import 'filter_provider.dart';
import 'labeled.dart';
import 'labeled_list.dart';
import 'side_sheet.dart';

class FiltersAndSearch extends ConsumerWidget {
  const FiltersAndSearch({super.key, this.onClose});

  final void Function()? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final querySource = ref.watch(querySourceProvider);
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topLeft,
      curve: Curves.easeOutCubic,
      child:
          querySource == QuerySource.searchAndFilter
              ? Filters(onClose: onClose)
              : AdvancedSearch(onClose: onClose),
    );
  }
}

class Filters extends ConsumerWidget {
  const Filters({super.key, this.onClose});

  final void Function()? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attributes = ref.watch(attributesStreamProvider).value ?? {};

    return SideSheet.detached(
      title: Text('Filters'),
      topActions: [
        IconButton(
          icon: Icon(Icons.refresh),
          tooltip: 'Reset',
          onPressed: () {
            ref.read(filterOptionsProvider.notifier).reset();
          },
        ),
        IconButton(
          icon: Icon(Icons.close),
          tooltip: 'Close',
          onPressed: onClose,
        ),
      ],
      bottomActions: [
        OutlinedButton.icon(
          icon: Icon(Icons.auto_awesome),
          label: Text('Advanced search'),
          onPressed: () {
            ref.read(querySourceProvider.notifier).state =
                QuerySource.advancedSearch;
          },
        ),
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
