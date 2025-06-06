import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AttributeDeleteDialog extends ConsumerWidget {
  const AttributeDeleteDialog({super.key, required this.attributePaths});

  final Set<AttributePath> attributePaths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(
      attributesUsedCountProvider(AttributesArgument(attributePaths)),
    );

    if (snapshot.isLoading || !snapshot.hasValue) {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    }

    final materialCount = snapshot.requireValue;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: AlertDialog(
          icon: Icon(Icons.delete_outlined),
          title: Text(
            attributePaths.length > 1
                ? 'Delete attributes?'
                : 'Delete attribute?',
          ),
          content: Text(
            attributePaths.length > 1
                ? 'Deleting these attributes will also remove them from $materialCount materials. This action cannot be undone.'
                : 'Deleting this attribute will also remove it from $materialCount materials. This action cannot be undone.',
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

Future<bool> confirmAttributeDeletion(
  BuildContext context,
  Set<AttributePath> attributes,
) async {
  if (attributes.isEmpty) {
    return true;
  }
  final delete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AttributeDeleteDialog(attributePaths: attributes);
    },
  );
  return delete ?? false;
}
