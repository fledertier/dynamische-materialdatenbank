import 'package:dynamische_materialdatenbank/custom_search/querry_builder.dart';
import 'package:dynamische_materialdatenbank/custom_search/query_service.dart';
import 'package:dynamische_materialdatenbank/providers/attribute_provider.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_scaffold.dart';
import '../constants.dart';
import '../header/header.dart';
import '../navigation.dart';
import '../services/attribute_service.dart';

class CustomSearchPage extends ConsumerStatefulWidget {
  const CustomSearchPage({super.key});

  @override
  ConsumerState<CustomSearchPage> createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends ConsumerState<CustomSearchPage> {
  Future<List<Json>> executeQuery(MaterialQuery query) async {
    final attributeIds = query.attributeIds();
    final parameter = AttributesParameter(attributeIds);
    final materialsById = await ref.read(
      attributesValuesStreamProvider(parameter).future,
    );
    final materials = materialsById.values.toList();
    return ref.read(queryServiceProvider).execute(query, materials);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      header: Header(),
      navigation: Navigation(page: Pages.attributes),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text("Custom Search", style: theme.textTheme.headlineSmall),
                ],
              ),
            ),
            Expanded(
              child: QueryBuilder(
                onExecute: (query) async {
                  final result = await executeQuery(query);

                  debugPrint("Found ${result.length} results");
                  for (final material in result.take(8)) {
                    debugPrint(material.toString());
                  }
                  if (result.length > 8) {
                    debugPrint("+ ${result.length - 8} more");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
