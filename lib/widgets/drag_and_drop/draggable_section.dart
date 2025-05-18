import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../material/attribute/add_attribute_card.dart';
import '../../material/attribute/cards.dart';
import '../../material/edit_mode_button.dart';

final sectionsProvider = StateProvider<List<CardSection>>(
  (ref) => throw UnimplementedError(),
);

final draggingItemProvider = StateProvider<CardData?>((ref) => null);
final fromSectionIndexProvider = StateProvider<int?>((ref) => null);

class DraggableSection extends ConsumerWidget {
  const DraggableSection({
    super.key,
    required this.materialId,
    required this.sectionIndex,
    required this.itemBuilder,
  });

  final String materialId;
  final int sectionIndex;
  final Widget Function(BuildContext context, CardData item) itemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    final sections = ref.watch(sectionsProvider);
    final section = sections[sectionIndex];
    final items = section.cards;
    // final draggingItem = ref.watch(draggingItemProvider);
    final fromSectionIndex = ref.watch(fromSectionIndexProvider);
    final edit = ref.watch(editModeProvider);

    final nameField = Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: section.nameDe,
        enabled: edit,
        style: textTheme.titleMedium?.copyWith(fontFamily: 'Lexend'),
        decoration: InputDecoration.collapsed(hintText: 'Section Name'),
        maxLines: null,
        onChanged: (value) {
          ref.read(sectionsProvider.notifier).update((sections) {
            sections[sectionIndex] = sections[sectionIndex].copyWith(
              nameDe: value,
            );
            return sections;
          });
        },
      ),
    );

    Widget nonDraggable(CardData item) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: itemBuilder(context, item),
      );
    }

    Widget draggable(CardData item) {
      final child = itemBuilder(context, item);
      return Draggable<CardData>(
        data: item,
        maxSimultaneousDrags: 1,
        onDragStarted: () {
          ref.read(draggingItemProvider.notifier).state = item;
          ref.read(fromSectionIndexProvider.notifier).state = sectionIndex;
        },
        onDragEnd: (_) {
          ref.invalidate(draggingItemProvider);
          ref.invalidate(fromSectionIndexProvider);
        },
        feedback: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            elevation: 8,
            child: child,
          ),
        ),
        childWhenDragging: Padding(
          padding: const EdgeInsets.all(8),
          child: Opacity(opacity: 0, child: child),
        ),
        child: DragTarget<CardData>(
          onWillAcceptWithDetails: (details) => details.data != item,
          onAcceptWithDetails: (details) {
            ref.read(sectionsProvider.notifier).update((sections) {
              final updated = [...sections];
              final insertIndex = updated[sectionIndex].cards.indexOf(item);
              updated[fromSectionIndex!].cards.remove(details.data);
              updated[sectionIndex].cards.insert(insertIndex, details.data);
              return updated;
            });
            ref.invalidate(draggingItemProvider);
            ref.invalidate(fromSectionIndexProvider);
          },
          builder: (context, candidateData, rejectedData) {
            final colorScheme = ColorScheme.of(context);
            return Padding(
              padding: const EdgeInsets.all(8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color:
                        candidateData.isNotEmpty
                            ? colorScheme.outline
                            : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    }

    Widget container({bool highlighted = false}) {
      final hasName = section.nameDe?.isNotEmpty ?? false;
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                highlighted
                    ? colorScheme.outline
                    : edit
                    ? colorScheme.outlineVariant
                    : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasName || edit) nameField,
            Wrap(
              children: [
                ...List.generate(items.length, (itemIndex) {
                  final item = items[itemIndex];
                  return edit ? draggable(item) : nonDraggable(item);
                }),
                if (edit)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: AddAttributeCardButton(
                      materialId: materialId,
                      onAdded: (card) {
                        ref.read(sectionsProvider.notifier).update((sections) {
                          sections[sectionIndex].cards.add(card);
                          return sections;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    if (!edit) {
      return container();
    }

    return DragTarget<CardData>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        if (fromSectionIndex == sectionIndex) return;

        ref.read(sectionsProvider.notifier).update((sections) {
          final updated = [...sections];
          updated[fromSectionIndex!].cards.remove(details.data);
          updated[sectionIndex].cards.add(details.data);
          return updated;
        });

        ref.invalidate(draggingItemProvider);
        ref.invalidate(fromSectionIndexProvider);
      },
      builder: (context, candidateData, _) {
        return container(highlighted: candidateData.isNotEmpty);
      },
    );
  }
}
