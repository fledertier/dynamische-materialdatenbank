import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

final editModeProvider = StateProvider.autoDispose((ref) => true);

class EditModeButton extends ConsumerWidget {
  const EditModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);

    if (edit) {
      return SizedBox(
        width: 97,
        child: FilledButton.icon(
          icon: Icon(Symbols.visibility),
          label: Text('View'),
          onPressed: () {
            ref.read(editModeProvider.notifier).state = false;
          },
        ),
      );
    } else {
      return SizedBox(
        width: 97,
        child: OutlinedButton.icon(
          icon: Icon(Symbols.edit),
          label: Text('Edit'),
          onPressed: () {
            ref.read(editModeProvider.notifier).state = true;
          },
        ),
      );
    }
  }
}
