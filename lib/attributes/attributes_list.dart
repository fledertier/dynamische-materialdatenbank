import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attribute_provider.dart';

class AttributesList extends ConsumerWidget {
  const AttributesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(attributesProvider);

    if (snapshot.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final attributes = snapshot.requireValue;

    return ListView.builder(
      itemCount: attributes.length,
      itemBuilder: (context, index) {
        final attribute = attributes[index];
        return ListTile(
          leading: Icon(attribute.type.icon()),
          title: Text(attribute.name),
          subtitle: Text(attribute.type.name),
          onTap: () {},
        );
      },
    );
  }
}
