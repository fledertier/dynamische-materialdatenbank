import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attribute/cards.dart';
import 'draggable_cards_builder.dart';

class SectionButton extends ConsumerWidget {
  const SectionButton({super.key, required this.sectionCategory});

  final SectionCategory sectionCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        fixedSize: Size(double.infinity, 80),
      ),
      icon: Icon(Icons.add),
      label: Text('Add Section'),
      onPressed: () {
        ref.read(sectionsProvider(sectionCategory).notifier).update((sections) {
          final newSection = CardSection(cards: []);
          return [...sections, newSection];
        });
      },
    );
  }
}
