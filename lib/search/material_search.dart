import 'package:dynamische_materialdatenbank/search/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../attributes/attribute_provider.dart';
import '../constants.dart';
import '../material/material_provider.dart';
import '../widgets/highlighted_text.dart';
import 'search.dart';
import 'search_service.dart';

class MaterialSearch extends ConsumerWidget {
  const MaterialSearch({super.key, this.onFilter});

  final void Function()? onFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchControllerProvider);
    return Search(
      hintText: 'Search in materials',
      controller: controller,
      search: (query) async {
        final attributes = AttributesParameter({Attributes.name});
        final materials = await ref.read(
          materialsStreamProvider(attributes).future,
        );
        return ref
            .read(searchServiceProvider)
            .search(materials, attributes.attributes, query);
      },
      buildSuggestion: (material, query) {
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
      onSubmitted: (query) {
        controller.closeView(query);
        ref.read(searchProvider.notifier).state = query;
      },
      onClear: () {
        controller.closeView('');
        ref.read(searchProvider.notifier).state = '';
      },
      onFilter: onFilter,
    );
  }
}
