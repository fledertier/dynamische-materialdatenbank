import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'attribute.dart';
import 'attribute_provider.dart';
import 'attribute_service.dart';

class AttributeDeleteDialog extends ConsumerWidget {
  const AttributeDeleteDialog({super.key, required this.attribute});

  final Attribute attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(attributeValuesProvider(attribute.id));

    if (snapshot.isLoading || !snapshot.hasValue) {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    }

    final numberOfEntries = snapshot.requireValue.length;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: AlertDialog(
          title: const Text("Delete Attribute"),
          content: Text(
            "Are you sure you want to delete the attribute '${attribute.name}', "
            "including its $numberOfEntries entries in materials?",
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(attributeServiceProvider)
                    .deleteAttribute(attribute.id);
                context.pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showAttributeDeleteDialog(
  BuildContext context,
  Attribute attribute,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AttributeDeleteDialog(attribute: attribute),
      ) ??
      false;
}
