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
        final attributes =
            (await ref
                    .read(firestoreProvider)
                    .collection(Collections.attributes)
                    .doc(Docs.attributes)
                    .get())
                .data();
        if (attributes != null) {
          downloadJson(attributes, 'attributes.json');
        }
      },
    );
  }
}
