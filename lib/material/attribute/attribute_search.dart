import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../attributes/attribute.dart';
import '../../search/search.dart';
import '../../widgets/highlighted_text.dart';

class AttributeSearch extends ConsumerStatefulWidget {
  const AttributeSearch({
    super.key,
    this.autofocus = false,
    required this.onSubmit,
  });

  final bool autofocus;
  final void Function(List<Attribute>) onSubmit;

  @override
  ConsumerState<AttributeSearch> createState() => _AttributeSearchState();
}

class _AttributeSearchState extends ConsumerState<AttributeSearch> {
  final controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return Search(
      hintText: 'Search for attributes',
      autoFocus: widget.autofocus,
      controller: controller,
      search: searchAttributes,
      buildSuggestion: (attribute, query) {
        return ListTile(
          title: HighlightedText(attribute.name, highlighted: query),
          onTap: () {
            controller.closeView(attribute.name);
            widget.onSubmit.call([attribute]);
          },
        );
      },
      onSubmitted: (query) async {
        final attributes = await searchAttributes(query);
        widget.onSubmit.call(attributes);
      },
    );
  }

  Future<List<Attribute>> searchAttributes(String query) async {
    final name = query.trim();
    final attributes = await ref.read(attributesStreamProvider.future);
    return attributes.values
        .where((attribute) => attribute.name.containsIgnoreCase(name))
        .sortedBy((attribute) => attribute.name)
        .toList();
  }
}
