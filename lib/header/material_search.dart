import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/attribute_provider.dart';
import 'search.dart';

class MaterialSearch extends ConsumerStatefulWidget {
  const MaterialSearch({super.key});

  @override
  ConsumerState<MaterialSearch> createState() => _MaterialSearchState();
}

class _MaterialSearchState extends ConsumerState<MaterialSearch> {
  late final SearchController controller;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
    controller.value = TextEditingValue(text: ref.read(searchProvider));
  }

  @override
  Widget build(BuildContext context) {
    final names = ref.watch(attributeProvider('name')).value ?? {};
    return Search(
      hintText: 'Search in materials',
      controller: controller,
      search: (query) {
        return names.entries.where((entry) {
          return entry.value.toLowerCase().contains(query.toLowerCase());
        }).toList();
      },
      buildSuggestion: (suggestion) {
        return ListTile(
          title: Text(suggestion.value),
          onTap: () {
            controller.closeView('');
            context.pushNamed(
              'details',
              pathParameters: {'materialId': suggestion.key},
            );
          },
        );
      },
      onSubmitted: (value) {
        controller.closeView(value);
        ref.read(searchProvider.notifier).query = value;
      },
      onClear: () {
        controller.closeView('');
        ref.read(searchProvider.notifier).query = '';
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
