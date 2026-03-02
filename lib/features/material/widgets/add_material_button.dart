import 'package:dynamische_materialdatenbank/features/material/providers/material_provider.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/shared/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddMaterialButton extends ConsumerWidget {
  const AddMaterialButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.large(
      child: Icon(Icons.add),
      onPressed: () {
        final id = generateId();
        ref.read(materialProvider(id).notifier).createMaterial();
        context.pushNamed(
          Pages.material,
          pathParameters: {'materialId': id},
          queryParameters: {'edit': 'true'},
        );
      },
    );
  }
}
