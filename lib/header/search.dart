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
  final List<T> Function(String query) search;
  final Widget Function(T suggestion) buildSuggestion;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final void Function()? onClear;

  @override
  Widget build(BuildContext context) {
    final leading = IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        onSubmitted?.call(controller.text);
      },
    );
    final trailing = IconButton(
      icon: const Icon(Icons.close),
      tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
      onPressed: onClear,
    );
    return SearchAnchor(
      searchController: controller,
      viewLeading: leading,
      viewTrailing: [
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return controller.text.isEmpty ? const SizedBox() : trailing;
          },
        ),
      ],
      viewOnChanged: (value) {},
      viewOnSubmitted: onSubmitted,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          leading: leading,
          hintText: hintText,
          onTap: controller.openView,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.text;
        if (query.isEmpty) {
          return [];
        }
        final suggestions = search(query);
        return suggestions.map(buildSuggestion);
      },
    );
  }
}
