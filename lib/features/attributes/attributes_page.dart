import 'package:dynamische_materialdatenbank/core/app/app_scaffold.dart';
import 'package:dynamische_materialdatenbank/shared/widgets/header.dart';
import 'package:dynamische_materialdatenbank/core/app/navigation.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attribute_details.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attributes_export_button.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attributes_import_button.dart';
import 'package:dynamische_materialdatenbank/features/attributes/attributes_list.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/shared/widgets/sheet.dart';
import 'package:flutter/material.dart';

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
      header: Header(
        actions: [AttributesImportButton(), AttributesExportButton()],
      ),
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
