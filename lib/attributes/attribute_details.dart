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
              child: Row(
                children: [
                  Text(
                    switch(mode.value) {
                      CreateAttributeMode _ => "Create Attribute",
                      EditAttributeMode _ => "Edit Attribute",
                      _ => "",
                    },
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacer(),
                  if (mode.value is EditAttributeMode)
                    FilledButton.tonalIcon(
                      label: Text("Delete"),
                      icon: Icon(Symbols.delete),
                      onPressed: () {},
                    ),
                ],
              ),
            ),
            Expanded(
              key: ValueKey(mode.value),
              child:
                  switch(mode.value) {
                    final CreateAttributeMode _ => CreateAttributeForm(
                      onCreateAttribute: (attribute) {
                        ref
                            .read(attributeServiceProvider)
                            .createAttribute(attribute);
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
      }
    );
  }
}
