import 'package:flutter/material.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../constants.dart';
import '../header/header.dart';
import '../widgets/sheet.dart';
import 'attribute_details.dart';
import 'attributes_export_button.dart';
import 'attributes_list.dart';

class AttributesPage extends StatefulWidget {
  const AttributesPage({super.key});

  @override
  State<AttributesPage> createState() => _AttributesPageState();
}

class _AttributesPageState extends State<AttributesPage> {
  final selectedAttributeId = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: Header(actions: [AttributesExportButton()]),
      navigation: Navigation(page: Pages.attributes),
      body: Row(
        spacing: 24,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 412),
            child: AttributesList(selectedAttributeId: selectedAttributeId),
          ),
          Expanded(
            child: Sheet(
              child: AttributeDetails(selectedAttributeId: selectedAttributeId),
            ),
          ),
        ],
      ),
    );
  }
}
