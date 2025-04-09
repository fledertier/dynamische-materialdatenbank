import 'package:dynamische_materialdatenbank/providers/router_provider.dart';
import 'package:flutter/material.dart';

import '../app_scaffold.dart';
import '../header/header.dart';
import '../navigation.dart';

class AttributesPage extends StatelessWidget {
  const AttributesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: Header(),
      navigation: Navigation(page: Pages.attributes),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Placeholder(),
      ),
      sidebar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Placeholder(),
      ),
    );
  }
}
