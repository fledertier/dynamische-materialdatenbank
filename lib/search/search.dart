import 'dart:async';

import 'package:flutter/material.dart';

const double minViewHeight = 240 - 56 - 1;

class Search<T> extends StatelessWidget {
  const Search({
    super.key,
    this.hintText,
    required this.controller,
    required this.search,
    required this.buildSuggestion,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFilter,
  });

  final String? hintText;
  final SearchController controller;
  final FutureOr<List<T>> Function(String query) search;
  final Widget Function(T suggestion, String query) buildSuggestion;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final void Function()? onClear;
  final void Function()? onFilter;

  @override
  Widget build(BuildContext context) {
    final clear = IconButton(
      icon: const Icon(Icons.close),
      tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
      onPressed: onClear,
    );
    final filter = IconButton(
      icon: Icon(Icons.tune),
      tooltip: 'Filters',
      onPressed: onFilter,
    );
    return SearchAnchor.bar(
      searchController: controller,
      barHintText: hintText,
      barTrailing: [if (onFilter != null) filter],
      barPadding: WidgetStatePropertyAll(EdgeInsets.only(left: 16, right: 8)),
      viewLeading: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(Icons.search),
      ),
      viewTrailing: [
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return value.text.isEmpty ? const SizedBox() : clear;
          },
        ),
        if (onFilter != null) filter,
      ],
      viewBuilder: (suggestions) {
        final query = controller.text;
        if (query.isNotEmpty && suggestions.isEmpty) {
          return SizedBox(
            height: minViewHeight,
            child: Center(child: Text('No results found')),
          );
        }
        return ListView(shrinkWrap: true, children: suggestions.toList());
      },
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suggestionsBuilder: (context, controller) async {
        final query = controller.text;
        final suggestions = await search(query);
        return suggestions.map(
          (suggestion) => buildSuggestion(suggestion, query),
        );
      },
    );
  }
}
