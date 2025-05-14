import 'package:dynamische_materialdatenbank/attributes/attribute_delete_dialog.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../widgets/directional_menu_anchor.dart';
import 'attribute.dart';
import 'attribute_form.dart';
import 'attribute_service.dart';

class AttributeDetails extends ConsumerWidget {
  const AttributeDetails({super.key, required this.selectedAttribute});

  final ValueNotifier<Attribute?> selectedAttribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: selectedAttribute,
      builder: (context, child) {
        if (selectedAttribute.value == null) {
          return Center(
            child: Text(
              "Select an attribute to edit",
              style: TextStyle(color: ColorScheme.of(context).onSurfaceVariant),
            ),
          );
        }
        return Column(
          children: [
            SizedBox(
              height: 76,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      selectedAttribute.value != null
                          ? "Edit Attribute"
                          : "Create Attribute",
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    Spacer(),
                    DirectionalMenuAnchor(
                      directionality: TextDirection.rtl,
                      builder: (context, controller, child) {
                        return IconButton(
                          onPressed: controller.toggle,
                          icon: Icon(Icons.more_vert),
                        );
                      },
                      menuChildren: [
                        if (selectedAttribute.value != null)
                          MenuItemButton(
                            leadingIcon: Icon(Symbols.content_copy),
                            requestFocusOnHover: false,
                            onPressed: copyAttributeId,
                            child: Text('Copy id'),
                          ),
                        if (selectedAttribute.value != null)
                          MenuItemButton(
                            leadingIcon: Icon(Symbols.delete),
                            requestFocusOnHover: false,
                            onPressed: () {
                              deleteAttribute(context);
                            },
                            child: Text("Delete"),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              key: ValueKey(selectedAttribute.value),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AttributeForm(
                  initialAttribute: selectedAttribute.value,
                  onSubmit: (attribute) {
                    ref
                        .read(attributeServiceProvider)
                        .updateAttribute(attribute);
                    selectedAttribute.value = attribute;
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAttribute(BuildContext context) async {
    final deleted = await showAttributeDeleteDialog(
      context,
      selectedAttribute.value!,
    );
    if (deleted) {
      selectedAttribute.value = null;
    }
  }

  void copyAttributeId() {
    final attribute = selectedAttribute.value!;
    Clipboard.setData(ClipboardData(text: attribute.id));
  }
}
