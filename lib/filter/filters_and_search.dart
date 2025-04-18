import 'package:dynamische_materialdatenbank/advanced_search/querry_builder.dart';
import 'package:dynamische_materialdatenbank/filter/slider_filter_option.dart';
import 'package:dynamische_materialdatenbank/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../advanced_search/advanced_search_provider.dart';
import '../constants.dart';
import '../providers/attribute_provider.dart';
import 'checkbox_filter_option.dart';
import 'dropdown_menu_filter_option.dart';
import 'labeled.dart';
import 'labeled_list.dart';
import 'side_sheet.dart';

enum View { filters, advancedSearch }

class FiltersAndSearch extends StatefulWidget {
  const FiltersAndSearch({super.key});

  @override
  State<FiltersAndSearch> createState() => _FiltersAndSearchState();
}

class _FiltersAndSearchState extends State<FiltersAndSearch> {
  View _currentView = View.filters;

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
      curve: Curves.easeOutCubic,
      child:
          _currentView == View.filters
              ? Filters(onAdvancedSearch: showAdvancedSearch)
              : AdvancedSearch(onFilters: showFilters),
    );
  }
}

class Filters extends ConsumerWidget {
  const Filters({super.key, this.onAdvancedSearch});

  final void Function()? onAdvancedSearch;

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
        OutlinedButton.icon(
          icon: Icon(Icons.auto_awesome),
          label: Text('Advanced Search'),
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

class AdvancedSearch extends ConsumerWidget {
  const AdvancedSearch({super.key, this.onFilters});

  final void Function()? onFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSheet.detached(
      leading: BackButton(onPressed: onFilters),
      title: Text('Advanced Search'),
      topActions: [IconButton(icon: Icon(Icons.close), onPressed: () {})],
      width: 640,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QueryBuilder(
              onQuery: (query) {
                ref.read(queryProvider.notifier).state = query;
              },
            ),
          ],
        ),
      ),
    );
  }
}
