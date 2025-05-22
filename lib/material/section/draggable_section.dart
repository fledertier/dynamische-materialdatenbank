import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/miscellaneous_utils.dart';
import '../attribute/cards.dart';
import '../edit_mode_button.dart';
import 'draggable_cards_builder.dart';

class DraggableSection extends ConsumerWidget {
  const DraggableSection({
    super.key,
    required this.materialId,
    required this.sectionIndex,
    required this.sectionCategory,
    required this.itemBuilder,
    this.textStyle,
    this.itemMargin = EdgeInsets.zero,
    this.labelPadding = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  });

  final String materialId;
  final int sectionIndex;
  final SectionCategory sectionCategory;
  final Widget Function(BuildContext context, CardData item) itemBuilder;
  final TextStyle? textStyle;
  final EdgeInsets itemMargin;
  final EdgeInsets labelPadding;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);

    final sections = ref.watch(sectionsProvider(sectionCategory));
    final section = sections[sectionIndex];
    final items = section.cards;
    final edit = ref.watch(editModeProvider);

    // todo: update material after focus lost
    final nameField = Padding(
      padding: labelPadding,
      child: TextFormField(
        initialValue: section.nameDe,
        enabled: edit,
        style: textStyle,
        decoration: InputDecoration.collapsed(hintText: 'Section Name'),
        maxLines: null,
        onChanged: (value) {
          ref.read(sectionsProvider(sectionCategory).notifier).update((
            sections,
          ) {
            sections[sectionIndex] = sections[sectionIndex].copyWith(
              nameDe: value,
            );
            return sections;
          });
        },
      ),
    );

    Widget nonDraggableBuilder(int index) {
      final item = items[index];
      final child = itemBuilder(context, item);
      return Padding(padding: itemMargin, child: child);
    }

    Widget container({
      Widget Function(int index)? draggableBuilder,
      bool highlighted = false,
    }) {
      final hasName = section.nameDe?.isNotEmpty ?? false;
      return Container(
        constraints: BoxConstraints(
          maxWidth: widthByColumns(5),
          minHeight: 100,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                highlighted
                    ? colorScheme.primary
                    : edit
                    ? colorScheme.outline.withValues(alpha: 0.5)
                    : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasName || edit) nameField,
            Wrap(
              children: [
                ...List.generate(items.length, (index) {
                  if (!edit) {
                    return nonDraggableBuilder(index);
                  }
                  return draggableBuilder!(index);
                }),
              ],
            ),
          ],
        ),
      );
    }

    if (!edit) {
      return container(highlighted: false);
    }

    return DraggableCardsBuilder(
      materialId: materialId,
      sectionIndex: sectionIndex,
      sectionCategory: sectionCategory,
      padding: itemMargin,
      itemBuilder: (context, item) {
        return itemBuilder(context, item);
      },
      containerBuilder: (context, itemBuilder, highlighted) {
        return container(
          draggableBuilder: itemBuilder,
          highlighted: highlighted,
        );
      },
    );
  }
}

class InsertIndicator extends StatelessWidget {
  const InsertIndicator({
    super.key,
    required this.isBefore,
    required this.child,
  });

  final bool isBefore;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 16,
          bottom: 16,
          left: isBefore ? 0 : null,
          right: isBefore ? null : 0,
          width: 4,
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: ColorScheme.of(context).primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
