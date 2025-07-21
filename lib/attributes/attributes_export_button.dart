import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/utils/web_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributesExportButton extends ConsumerWidget {
  const AttributesExportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(Icons.download_outlined),
      label: Text('Export'),
      onPressed: () async {
        final attributes = await readAttributes(ref);
        if (attributes != null) {
          downloadJson(attributes, 'attributes.json');
        }

        final materials = await readMaterials(ref);
        if (materials.isNotEmpty) {
          downloadJson(materials.toList(), 'materials.json');
        }

        final colors = await readColors(ref);
        if (colors != null) {
          downloadJson(colors, 'colors.json');
        }
      },
    );
  }

  Future<Json?> readAttributes(WidgetRef ref) async {
    return (await ref
            .read(firestoreProvider)
            .collection(Collections.attributes)
            .doc(Docs.attributes)
            .get())
        .data();
  }

  Future<Iterable<Json>> readMaterials(WidgetRef ref) async {
    return (await ref
            .read(firestoreProvider)
            .collection(Collections.materials)
            .get())
        .docs
        .map((doc) => doc.data());
  }

  Future<Json?> readColors(WidgetRef ref) async {
    return (await ref
            .read(firestoreProvider)
            .collection(Collections.colors)
            .doc(Docs.materials)
            .get())
        .data();
  }
}
