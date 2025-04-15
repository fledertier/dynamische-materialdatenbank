import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../providers/attribute_provider.dart';
import '../providers/material_provider.dart';
import '../services/search_service.dart';
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Search(
      hintText: 'Search in materials',
      controller: controller,
      search: (query) async {
        final attributes = AttributesParameter({
          Attributes.name,
          Attributes.description,
        });
        final materials = await ref.read(
          materialsStreamProvider(attributes).future,
        );
        return ref.read(searchServiceProvider).search(materials, query);
      },
      buildSuggestion: (material) {
        return ListTile(
          title: Text(material[Attributes.name]),
          onTap: () {
            controller.closeView('');
            context.pushNamed(
              Pages.material,
              pathParameters: {'materialId': material[Attributes.id]},
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
}
