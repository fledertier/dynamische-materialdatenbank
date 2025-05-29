import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/directional_menu_anchor.dart';
import 'package:dynamische_materialdatenbank/widgets/loading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'attribute.dart';
import 'attribute_delete_dialog.dart';
import 'attribute_dialog.dart';
import 'attribute_provider.dart';
import 'attributes_provider.dart';
import 'attribute_table.dart';

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
            if (attribute == null) {
              return Center(
                child: Text(
                  'Select an attribute to edit',
                  style: TextStyle(
                    color: ColorScheme
                        .of(context)
                        .onSurfaceVariant,
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
                      spacing: 8,
                      children: [
                        LoadingText(
                          attribute.name,
                          style: TextTheme
                              .of(context)
                              .headlineSmall,
                        ),
                        Spacer(),
                        OutlinedButton.icon(
                          icon: Icon(Symbols.edit),
                          label: Text('Edit'),
                          onPressed: () {
                            editAttribute(context, ref, attribute);
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
                                copyAttributeId(context, attribute);
                              },
                              child: Text('Copy id'),
                            ),
                            MenuItemButton(
                              leadingIcon: Icon(Symbols.delete),
                              requestFocusOnHover: false,
                              onPressed: () {
                                deleteAttribute(context, ref, attribute);
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: AttributeTable(attribute: selectedAttributeId.value!),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editAttribute(BuildContext context,
      WidgetRef ref,
      Attribute attribute,) async {
    showAttributeDialog(
      context: context,
      initialAttribute: attribute,
      onSave: (updatedAttribute) async {
        final removedAttributes = getRemovedAttributes(
          updatedAttribute,
          attribute,
        );
        final delete = await confirmAttributeDeletion(
          context,
          removedAttributes,
        );
        if (delete) {
          context.pop();
          await ref
              .read(attributesProvider.notifier)
              .updateAttribute(updatedAttribute);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Attribute saved')));
        }
      },
    );
  }

  Set<String> getRemovedAttributes(Attribute updatedAttribute,
      Attribute attribute,) {
    return _collectRemovedAttributes(updatedAttribute, attribute, attribute.id);
  }

  Set<String> _collectRemovedAttributes(Attribute attribute,
      Attribute initialAttribute,
      String parentAttributeId,) {
    final removedAttributes = <String>{};
    for (final initialChildAttribute in initialAttribute.childAttributes) {
      final childAttribute = attribute.childAttributes.firstWhereOrNull(
            (childAttribute) => childAttribute.id == initialChildAttribute.id,
      );
      final attributeId = [
        parentAttributeId,
        initialChildAttribute.id,
      ].join('.');
      if (childAttribute == null) {
        removedAttributes.add(attributeId);
      } else {
        removedAttributes.addAll(
          _collectRemovedAttributes(
            childAttribute,
            initialChildAttribute,
            attributeId,
          ),
        );
      }
    }
    return removedAttributes;
  }

  Future<void> deleteAttribute(BuildContext context,
      WidgetRef ref,
      Attribute attribute,) async {
    final delete = await confirmAttributeDeletion(context, {attribute.id});
    if (delete) {
      await ref.read(attributesProvider.notifier).deleteAttribute(attribute.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Attribute deleted')));
    }
  }

  void copyAttributeId(BuildContext context, Attribute attribute) {
    Clipboard.setData(ClipboardData(text: attribute.id));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Id copied to clipboard')));
  }
}

extension on Attribute {
  List<Attribute> get childAttributes {
    if (type case ObjectAttributeType(:final attributes)) {
      return attributes;
    } else if (type case ListAttributeType(:final attribute)) {
      return [if (attribute != null) attribute];
    }
    return [];
  }
}
