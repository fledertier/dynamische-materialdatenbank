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
  final controller = SearchController();

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
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
