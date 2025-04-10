import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attribute_provider.dart';

class AttributesList extends ConsumerWidget {
  const AttributesList({super.key, this.onTap});

  final void Function(Attribute attribute)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(attributesStreamProvider);

    if (snapshot.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final attributes = snapshot.value ?? [];

    return ListView.builder(
      itemCount: attributes.length,
      itemBuilder: (context, index) {
        final attribute = attributes[index];

        return AttributeListTile(
          attribute,
          onTap: () {
            onTap?.call(attribute);
          },
        );
      },
    );
  }
}

class AttributeListTile extends StatelessWidget {
  const AttributeListTile(this.attribute, {super.key, required this.onTap});

  final Attribute attribute;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: Icon(attribute.type.icon()),
        title: Text(attribute.name),
        subtitle: Text(
          [attribute.type.name, if (attribute.required) "required"].join(", "),
        ),
        onTap: onTap,
      ),
    );
  }
}
