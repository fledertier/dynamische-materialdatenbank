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
  final mode = ValueNotifier(AttributeMode.create);

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text("Attributes", style: Theme.of(context).textTheme.headlineSmall),
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
            Expanded(child: AttributesList(onTap: (attribute) {
              mode.value = AttributeMode.edit(attribute);
            })),
          ],
        ),
      ),
      sidebar: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListenableBuilder(
            listenable: mode,
            builder: (context, child) {
              return AttributeDetails(
                mode: mode.value,
              );
            }
          ),
        ),
      ),
    );
  }
}
