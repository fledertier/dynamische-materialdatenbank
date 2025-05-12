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
    this.trailing,
    this.autoFocus = false,
    this.focusNode,
  });

  final String? hintText;
  final SearchController controller;
  final FutureOr<List<T>> Function(String query) search;
  final Widget Function(T suggestion, String query) buildSuggestion;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final void Function()? onClear;
  final Widget? trailing;
  final bool autoFocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final leading = Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(Icons.search),
    );
    final clear = IconButton(
      icon: const Icon(Icons.close),
      tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
      onPressed: () {
        controller.closeView('');
        onClear?.call();
      },
    );
    return SearchAnchor(
      searchController: controller,
      builder: (context, controller) {
        return SearchBar(
          autoFocus: autoFocus,
          focusNode: focusNode,
          hintText: hintText,
          controller: controller,
          onTap: () {
            controller.openView();
          },
          onChanged: (value) {
            controller.openView();
          },
          onSubmitted: onSubmitted,
          leading: leading,
          trailing: [if (trailing != null) trailing!],
        );
      },
      viewHintText: hintText,
      viewOnChanged: onChanged,
      viewOnSubmitted: (value) {
        controller.closeView(value);
        onSubmitted?.call(value);
      },
      viewLeading: leading,
      viewTrailing: [
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return value.text.isEmpty ? const SizedBox() : clear;
          },
        ),
        if (trailing != null) trailing!,
      ],
      viewBuilder: (suggestions) {
        final query = controller.text;
        if (query.isNotEmpty && suggestions.isEmpty) {
          return SizedBox(
            height: minViewHeight,
            child: Center(child: Text('No results found')),
          );
        }
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 400),
          child: ListView(shrinkWrap: true, children: suggestions.toList()),
        );
      },
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
