import 'package:dynamische_materialdatenbank/filter/slider_filter_option.dart';
import 'package:dynamische_materialdatenbank/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../advanced_search/advanced_search.dart';
import '../constants.dart';
import '../providers/attribute_provider.dart';
import '../providers/filter_provider.dart';
import 'checkbox_filter_option.dart';
import 'dropdown_menu_filter_option.dart';
import 'labeled.dart';
import 'labeled_list.dart';
import 'side_sheet.dart';

enum View { filters, advancedSearch }

class FiltersAndSearch extends StatefulWidget {
  const FiltersAndSearch({super.key, this.onClose});

  final void Function()? onClose;

  @override
  State<FiltersAndSearch> createState() => _FiltersAndSearchState();
}

class _FiltersAndSearchState extends State<FiltersAndSearch> {
  View _currentView = View.advancedSearch;

  void showFilters() {
    setState(() {
      _currentView = View.filters;
    });
  }

  void showAdvancedSearch() {
    setState(() {
      _currentView = View.advancedSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topLeft,
      curve: Curves.easeOutCubic,
      child:
          _currentView == View.filters
              ? Filters(
                onClose: widget.onClose,
                onAdvancedSearch: showAdvancedSearch,
              )
              : AdvancedSearch(onClose: widget.onClose, onFilters: showFilters),
    );
  }
}

class Filters extends ConsumerWidget {
  const Filters({super.key, this.onClose, this.onAdvancedSearch});

  final void Function()? onClose;
  final void Function()? onAdvancedSearch;

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
            ref.read(filterProvider.notifier).reset();
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
          onPressed: onAdvancedSearch,
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
