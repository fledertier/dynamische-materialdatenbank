import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_dialog.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute_provider.dart';
import 'attribute_search_bar.dart';
import 'attribute_service.dart';

class AttributesList extends ConsumerStatefulWidget {
  const AttributesList({super.key, required this.selectedAttributeId});

  final ValueNotifier<String?> selectedAttributeId;

  @override
  ConsumerState<AttributesList> createState() => _AttributesListState();
}

class _AttributesListState extends ConsumerState<AttributesList> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(attributesProvider);
    if (snapshot.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final attributesById = snapshot.value ?? {};
    final attributes = attributesById.values.sortedBy(
      (attribute) => attribute.name,
    );

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: AttributeSearchBar(controller: searchController),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  widget.selectedAttributeId,
                  searchController,
                ]),
                builder: (context, child) {
                  final search = searchController.text;
                  final filterdAttributes = attributes.where(
                    (attribute) => attribute.name.containsIgnoreCase(search),
                  );

                  return ListView.builder(
                    itemCount: filterdAttributes.length,
                    itemBuilder: (context, index) {
                      final attribute = filterdAttributes.elementAt(index);

                      return AttributeListTile(
                        attribute,
                        selected:
                            widget.selectedAttributeId.value == attribute.id,
                        onTap: () {
                          widget.selectedAttributeId.value = attribute.id;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 32,
          right: 32,
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: createAttribute,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Future<void> createAttribute() async {
    final attribute = await showAttributeDialog(context);
    if (attribute != null) {
      await ref.read(attributeServiceProvider).updateAttribute(attribute);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Attribute created")));
      widget.selectedAttributeId.value = attribute.id;
    }
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
