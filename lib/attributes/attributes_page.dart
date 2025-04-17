import 'package:flutter/material.dart';

import '../app_scaffold.dart';
import '../constants.dart';
import '../header/header.dart';
import '../navigation.dart';
import 'attribute_details.dart';
import 'attribute_mode.dart';
import 'attributes_list.dart';

class AttributesPage extends StatefulWidget {
  const AttributesPage({super.key});

  @override
  State<AttributesPage> createState() => _AttributesPageState();
}

class _AttributesPageState extends State<AttributesPage> {
  final mode = ValueNotifier<AttributeMode?>(null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      header: Header(),
      navigation: Navigation(page: Pages.attributes),
      body: Row(
        spacing: 24,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 412),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text("Attributes", style: theme.textTheme.headlineSmall),
                      Spacer(),
                      FilledButton.tonalIcon(
                        label: Text("Add"),
                        icon: Icon(Icons.add),
                        onPressed: () {
                          mode.value = AttributeMode.create;
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(child: AttributesList(mode: mode)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AttributeDetails(mode: mode),
            ),
          ),
        ],
      ),
    );
  }
}
