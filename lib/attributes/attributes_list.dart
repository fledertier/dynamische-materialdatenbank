import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute_provider.dart';

class AttributesList extends StatelessWidget {
  const AttributesList({super.key, required this.selectedAttribute});

  final ValueNotifier<AttributeData?> selectedAttribute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Attributes", style: TextTheme.of(context).headlineSmall),
              FilledButton.tonalIcon(
                label: Text("Add"),
                icon: Icon(Icons.add),
                onPressed: () {
                  selectedAttribute.value = AttributeData();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final snapshot = ref.watch(attributesStreamProvider);

              if (snapshot.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final attributesById = snapshot.value ?? {};
              final attributes = attributesById.values.sortedBy(
                (attribute) => attribute.name,
              );

              return ListenableBuilder(
                listenable: selectedAttribute,
                builder: (context, child) {
                  return ListView.builder(
                    itemCount: attributes.length,
                    itemBuilder: (context, index) {
                      final attribute = attributes.elementAt(index);

                      return AttributeListTile(
                        attribute,
                        selected: selectedAttribute.value == attribute,
                        onTap: () {
                          selectedAttribute.value = attribute;
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class AttributeListTile extends StatelessWidget {
  const AttributeListTile(
    this.attribute, {
    super.key,
    this.selected = false,
    required this.onTap,
  });

  final Attribute attribute;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: Icon(attribute.type.icon),
        title: Text(attribute.name),
        subtitle: Text(
          [
            attribute.type.name,
            if (attribute.unitType != null) attribute.unitType!.name,
            if (attribute.required) "required",
          ].join(", "),
        ),
        selected: selected,
        textColor: ColorScheme.of(context).onSecondaryContainer,
        selectedTileColor: ColorScheme.of(context).secondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}
