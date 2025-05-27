import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'attribute.dart';
import 'attribute_provider.dart';

class AttributeDeleteDialog extends ConsumerWidget {
  const AttributeDeleteDialog({super.key, required this.attribute});

  final Attribute attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(valuesProvider(attribute.id));

    if (snapshot.isLoading || !snapshot.hasValue) {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    }

    final materialCount = snapshot.requireValue.length;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: AlertDialog(
          icon: Icon(Icons.delete_outlined),
          title: const Text('Delete attribute?'),
          content: Text(
            'Deleting this attribute will also remove it from $materialCount materials. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                context.pop();
              },
            ),
            FilledButton.tonal(
              child: const Text('Delete'),
              onPressed: () {
                context.pop(true);
              },
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
  final delete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AttributeDeleteDialog(attribute: attribute);
    },
  );
  return delete ?? false;
}
