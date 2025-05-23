import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Language { de, en }

final languageProvider = StateProvider((ref) => Language.de);

class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return SegmentedButton(
      segments: const [
        ButtonSegment(value: Language.de, label: Text('De')),
        ButtonSegment(value: Language.en, label: Text('En')),
      ],
      selected: {language},
      onSelectionChanged: (newSelection) {
        if (newSelection.isNotEmpty) {
          ref.read(languageProvider.notifier).state = newSelection.first;
        }
      },
    );
  }
}
