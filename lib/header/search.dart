import 'dart:async';

import 'package:flutter/material.dart';

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
  });

  final String? hintText;
  final SearchController controller;
  final FutureOr<List<T>> Function(String query) search;
  final Widget Function(T suggestion) buildSuggestion;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final void Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: controller,
      barHintText: hintText,
      viewTrailing: [
        ValueListenableBuilder(
          valueListenable: controller,
          child: IconButton(
            icon: const Icon(Icons.close),
            tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
            onPressed: onClear,
          ),
          builder: (context, value, child) {
            return value.text.isEmpty ? const SizedBox() : child!;
          },
        ),
      ],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suggestionsBuilder: (context, controller) async {
        final query = controller.text;
        if (query.isEmpty) {
          return [];
        }
        final suggestions = await search(query);
        return suggestions.map(buildSuggestion);
      },
    );
  }
}
