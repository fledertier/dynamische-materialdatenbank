import 'package:dynamische_materialdatenbank/services/attribute_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'attribute_form.dart';
import 'attribute_mode.dart';

class AttributeDetails extends ConsumerWidget {
  const AttributeDetails({super.key, required this.mode});

  final AttributeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                switch(mode) {
                  CreateAttributeMode _ => "Create Attribute",
                  EditAttributeMode _ => "Edit Attribute",
                  _ => "",
                },
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Spacer(),
              if (mode is EditAttributeMode)
                FilledButton.tonalIcon(
                  label: Text("Delete"),
                  icon: Icon(Symbols.delete),
                  onPressed: () {},
                ),
            ],
          ),
        ),
        Expanded(
          child:
              switch(mode) {
                final CreateAttributeMode _ => CreateAttributeForm(
                  onCreateAttribute: (attribute) {
                    ref
                        .read(attributeServiceProvider)
                        .createAttribute(attribute);
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
}
