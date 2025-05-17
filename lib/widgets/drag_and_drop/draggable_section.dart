import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../material/attribute/cards.dart';

final sectionsProvider = StateProvider<List<CardSection>>(
  (ref) => throw UnimplementedError(),
);

final draggingItemProvider = StateProvider<CardData?>((ref) => null);
final fromSectionIndexProvider = StateProvider<int?>((ref) => null);

class DraggableSection extends ConsumerWidget {
  const DraggableSection({
    super.key,
    required this.sectionIndex,
    required this.itemBuilder,
  });

  final int sectionIndex;
  final Widget Function(BuildContext context, CardData item) itemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(sectionsProvider);
    // final draggingItem = ref.watch(draggingItemProvider);
    final fromSectionIndex = ref.watch(fromSectionIndexProvider);
    final items = sections[sectionIndex].cards;

    return DragTarget<CardData>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        if (fromSectionIndex == sectionIndex) return;

        ref.read(sectionsProvider.notifier).update((sections) {
          sections[fromSectionIndex!].cards.remove(details.data);
          sections[sectionIndex].cards.add(details.data);
          return sections;
        });

        ref.invalidate(draggingItemProvider);
        ref.invalidate(fromSectionIndexProvider);
      },
      builder: (context, candidateData, _) {
        final colorScheme = ColorScheme.of(context);
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  candidateData.isNotEmpty
                      ? colorScheme.outline
                      : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            children: List.generate(items.length, (itemIndex) {
              final item = items[itemIndex];
              final child = itemBuilder(context, item);

              return Draggable<CardData>(
                data: item,
                maxSimultaneousDrags: 1,
                onDragStarted: () {
                  ref.read(draggingItemProvider.notifier).state = item;
                  ref.read(fromSectionIndexProvider.notifier).state =
                      sectionIndex;
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
                      final insertIndex = updated[sectionIndex].cards.indexOf(
                        item,
                      );
                      updated[fromSectionIndex!].cards.remove(details.data);
                      updated[sectionIndex].cards.insert(
                        insertIndex,
                        details.data,
                      );
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
            }),
          ),
        );
      },
    );
  }
}
