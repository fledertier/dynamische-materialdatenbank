import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class AttributesExportButton extends ConsumerWidget {
  const AttributesExportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonalIcon(
      icon: const Icon(Icons.download_outlined),
      label: Text('Export'),
      onPressed: () async {
        final attributes =
            (await FirebaseFirestore.instance
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
