import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/directional_menu_anchor.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'attribute.dart';
import 'attribute_delete_dialog.dart';
import 'attribute_dialog.dart';
import 'attribute_provider.dart';
import 'attribute_service.dart';

class AttributeDetails extends ConsumerWidget {
  const AttributeDetails({super.key, required this.selectedAttributeId});

  final ValueNotifier<String?> selectedAttributeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: selectedAttributeId,
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, child) {
            final attribute = ref.watch(
              attributeProvider(selectedAttributeId.value),
            );
            if (selectedAttributeId.value == null) {
              return Center(
                child: Text(
                  "Select an attribute to edit",
                  style: TextStyle(
                    color: ColorScheme.of(context).onSurfaceVariant,
                  ),
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
                        LoadingText(
                          attribute?.name,
                          style: TextTheme.of(context).headlineSmall,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Symbols.edit),
                          onPressed: () async {
                            final updatedAttribute = await showAttributeDialog(
                              context,
                              attribute,
                            );
                            if (updatedAttribute != null) {
                              ref
                                  .read(attributeServiceProvider)
                                  .updateAttribute(updatedAttribute);
                            }
                          },
                        ),
                        DirectionalMenuAnchor(
                          directionality: TextDirection.rtl,
                          builder: (context, controller, child) {
                            return IconButton(
                              onPressed: controller.toggle,
                              icon: Icon(Icons.more_vert),
                            );
                          },
                          menuChildren: [
                            MenuItemButton(
                              leadingIcon: Icon(Symbols.content_copy),
                              requestFocusOnHover: false,
                              onPressed: () {
                                copyAttributeId(attribute!);
                              },
                              child: Text('Copy id'),
                            ),
                            MenuItemButton(
                              leadingIcon: Icon(Symbols.delete),
                              requestFocusOnHover: false,
                              onPressed: () {
                                deleteAttribute(context, attribute!);
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
                  key: ValueKey(selectedAttributeId.value),
                  child: Padding(padding: const EdgeInsets.all(24)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteAttribute(
    BuildContext context,
    Attribute attribute,
  ) async {
    final deleted = await showAttributeDeleteDialog(context, attribute);
    if (deleted) {
      selectedAttributeId.value = null;
    }
  }

  void copyAttributeId(Attribute attribute) {
    Clipboard.setData(ClipboardData(text: attribute.id));
  }
}
