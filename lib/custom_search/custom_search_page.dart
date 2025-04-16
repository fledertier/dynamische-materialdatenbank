import 'package:dynamische_materialdatenbank/custom_search/querry_builder.dart';
import 'package:flutter/material.dart' hide TextField;

import '../app_scaffold.dart';
import '../constants.dart';
import '../header/header.dart';
import '../navigation.dart';

class CustomSearchPage extends StatefulWidget {
  const CustomSearchPage({super.key});

  @override
  State<CustomSearchPage> createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends State<CustomSearchPage> {
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
            Expanded(child: QueryBuilder()),
          ],
        ),
      ),
    );
  }
}
