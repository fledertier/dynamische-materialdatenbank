import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../material/attribute/cards.dart';
import '../../utils/miscellaneous_utils.dart';
import 'draggable_section.dart';

class AddSectionButton extends ConsumerWidget {
  const AddSectionButton({super.key, required this.sectionCategory});

  final SectionCategory sectionCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        fixedSize: Size(double.infinity, widthByColumns(1) * 0.5),
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
