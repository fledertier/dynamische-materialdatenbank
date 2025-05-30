import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:dynamische_materialdatenbank/widgets/highlighted_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'search.dart';
import 'search_provider.dart';
import 'search_service.dart';

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
    controller.text = ref.read(searchProvider);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchProvider, (previous, next) {
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
        final attributes = AttributesArgument({Attributes.name});
        final materials = await ref.read(materialsProvider(attributes).future);
        return ref
            .read(searchServiceProvider)
            .search(materials, attributes.attributes, query);
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
        ref.read(searchProvider.notifier).state = query;
      },
      onClear: () {
        ref.read(searchProvider.notifier).state = '';
      },
      trailing: widget.onFilter != null ? filter : null,
    );
  }
}
