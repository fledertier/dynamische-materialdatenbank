import 'package:flutter/material.dart';

class Search<T> extends StatelessWidget {
  const Search({
    super.key,
    this.hintText,
    this.controller,
    required this.search,
    required this.buildSuggestion,
  });

  final String? hintText;
  final SearchController? controller;
  final List<T> Function(String query) search;
  final Widget Function(T suggestion) buildSuggestion;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      builder: (context, controller) {
        return SearchBar(
          leading: Icon(Icons.search),
          hintText: hintText,
          controller: controller,
          onTap: () => controller.openView(),
          onChanged: (value) => controller.openView(),
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
