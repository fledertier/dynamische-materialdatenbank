import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attribute_provider.dart';
import 'attribute_mode.dart';

class AttributesList extends ConsumerWidget {
  const AttributesList({super.key, required this.mode});

  final ValueNotifier<AttributeMode?> mode;

  bool isSelected(Attribute attribute) {
    if (mode.value case final EditAttributeMode editMode) {
      return editMode.attribute == attribute;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(attributesStreamProvider);

    if (snapshot.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final attributes =
        snapshot.value?.values.sortedBy((attribute) => attribute.name) ?? [];

    return ListenableBuilder(
      listenable: mode,
      builder: (context, child) {
        return ListView.builder(
          itemCount: attributes.length,
          itemBuilder: (context, index) {
            final attribute = attributes.elementAt(index);

            return AttributeListTile(
              attribute,
              selected: isSelected(attribute),
              onTap: () {
                mode.value = AttributeMode.edit(attribute);
              },
            );
          },
        );
      },
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
            if (attribute.required ?? false) "required",
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
