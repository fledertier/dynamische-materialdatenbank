import 'package:dynamische_materialdatenbank/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../highlighted_text.dart';
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
  late String query;

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
        this.query = query;
        final attributes = AttributesParameter({Attributes.name});
        final materials = await ref.read(
          materialsStreamProvider(attributes).future,
        );
        return ref
            .read(searchServiceProvider)
            .search(materials, attributes.attributes, query);
      },
      buildSuggestion: (material) {
        final name = material[Attributes.name] as String;
        return ListTile(
          title: HighlightedText(name, highlighted: query),
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
