import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../providers/material_provider.dart';
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
    final materials = ref.watch(materialItemsStreamProvider).value;
    return Search(
      hintText: 'Search in materials',
      controller: controller,
      search: (query) {
        if (materials == null) return [];
        return search(materials, query);
      },
      buildSuggestion: (material) {
        return ListTile(
          title: Text(material['name']),
          onTap: () {
            controller.closeView('');
            context.pushNamed(
              Pages.material,
              pathParameters: {'materialId': material['id']},
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

List<Map<String, dynamic>> search(
  List<Map<String, dynamic>> materials,
  String query,
) {
  return materials.where((material) {
    return ["name", "description"].any((attribute) {
      return material[attribute].toLowerCase().contains(query.toLowerCase());
    });
  }).toList();
}
