import 'package:dynamische_materialdatenbank/attributes/attribute_delete_dialog.dart';
import 'package:dynamische_materialdatenbank/providers/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/services/attribute_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'attribute_form.dart';
import 'attribute_mode.dart';

class AttributeDetails extends ConsumerWidget {
  const AttributeDetails({super.key, required this.mode});

  final ValueNotifier<AttributeMode?> mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: mode,
      builder: (context, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Text(switch (mode.value) {
                      CreateAttributeMode _ => "Create Attribute",
                      EditAttributeMode _ => "Edit Attribute",
                      _ => "",
                    }, style: TextTheme.of(context).headlineSmall),
                    Spacer(),
                    if (mode.value case final EditAttributeMode editMode)
                      FilledButton.tonalIcon(
                        label: Text("Delete"),
                        icon: Icon(Symbols.delete),
                        onPressed: () async {
                          final deleted = await showAttributeDeleteDialog(
                            context,
                            editMode.attribute,
                          );
                          if (deleted) {
                            mode.value = null;
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              key: ValueKey(mode.value),
              child: switch (mode.value) {
                final CreateAttributeMode _ => CreateAttributeForm(
                  onCreateAttribute: (attribute) async {
                    final id = await nearestAvailableId(ref, attribute);
                    ref.read(attributeServiceProvider).createAttribute({
                      ...attribute,
                      "id": id,
                    });
                    mode.value = null;
                  },
                ),
                final EditAttributeMode editMode => EditAttributeForm(
                  attribute: editMode.attribute,
                  onEditAttribute: (attribute) {
                    ref
                        .read(attributeServiceProvider)
                        .updateAttribute(attribute);
                  },
                ),
                _ => SizedBox(),
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> nearestAvailableId(WidgetRef ref, Json attribute) async {
    final name =
        attribute["nameEn"] as String? ?? attribute["nameDe"] as String;
    final attributes = await ref.read(attributesStreamProvider.future);
    return ref
        .read(attributeServiceProvider)
        .nearestAvailableAttributeId(name.toLowerCase(), attributes);
  }
}
