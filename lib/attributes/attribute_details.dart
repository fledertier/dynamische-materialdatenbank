import 'package:dynamische_materialdatenbank/attributes/attribute_delete_dialog.dart';
import 'package:dynamische_materialdatenbank/providers/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/services/attribute_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'attribute.dart';
import 'attribute_form.dart';

class AttributeDetails extends ConsumerWidget {
  const AttributeDetails({super.key, required this.selectedAttribute});

  final ValueNotifier<AttributeData?> selectedAttribute;

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
                      selectedAttribute.value is Attribute
                          ? "Edit Attribute"
                          : "Create Attribute",
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    Spacer(),
                    FilledButton.tonalIcon(
                      label: Text("Delete"),
                      icon: Icon(Symbols.delete),
                      onPressed: () async {
                        bool? deleted;
                        if (selectedAttribute.value is Attribute) {
                          deleted = await showAttributeDeleteDialog(
                            context,
                            selectedAttribute.value as Attribute,
                          );
                        }
                        if (deleted ?? true) {
                          selectedAttribute.value = null;
                        }
                      },
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
                  initialAttribute: selectedAttribute.value!,
                  onSubmit: (attribute) async {
                    if (attribute is! Attribute) {
                      final id = await nearestAvailableId(ref, attribute);
                      attribute = Attribute.fromData(id, attribute);
                    }
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

  Future<String> nearestAvailableId(
    WidgetRef ref,
    AttributeData attribute,
  ) async {
    final name = attribute.nameEn ?? attribute.nameDe!;
    final attributes = await ref.read(attributesStreamProvider.future);
    return ref
        .read(attributeServiceProvider)
        .nearestAvailableAttributeId(name.toLowerCase(), attributes);
  }
}
