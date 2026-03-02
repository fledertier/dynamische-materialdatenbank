import 'package:dynamische_materialdatenbank/features/attributes/providers/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/features/material/providers/materials_provider.dart';
import 'package:dynamische_materialdatenbank/features/search/widgets/search.dart';
import 'package:dynamische_materialdatenbank/features/search/providers/search_providers.dart';
import 'package:dynamische_materialdatenbank/features/search/providers/search_service.dart';
import 'package:dynamische_materialdatenbank/shared/widgets/highlighted_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MaterialSearch extends ConsumerStatefulWidget {
  const MaterialSearch({super.key, this.onFilter});

  final void Function()? onFilter;

  @override
  ConsumerState<MaterialSearch> createState() => _MaterialSearchState();
}

class _MaterialSearchState extends ConsumerState<MaterialSearch> {
  late final SearchController controller;

  @override
  void initState() {
    super.initState();
    controller = SearchController();
    controller.text = ref.read(searchTextProvider);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchTextProvider, (previous, next) {
      controller.text = next;
    });

    final filter = IconButton(
      icon: Icon(Icons.tune),
      tooltip: 'Filters',
      onPressed: widget.onFilter,
    );

    return Search(
      hintText: 'Search in materials',
      controller: controller,
      search: (query) async {
        if (query.isEmpty) {
          return [];
        }
        final attributes = {AttributePath(Attributes.name)};
        final materials = await ref.read(
          materialsProvider(AttributesArgument(attributes)).future,
        );
        final searchService = await ref.read(searchServiceProvider.future);
        return searchService.search(materials, attributes, query);
      },
      buildSuggestion: (material, query) {
        final name = TranslatableText.fromJson(material[Attributes.name]).value;
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
        ref.read(searchTextProvider.notifier).state = query;
      },
      onClear: () {
        ref.read(searchTextProvider.notifier).state = '';
      },
      trailing: widget.onFilter != null ? filter : null,
    );
  }
}
