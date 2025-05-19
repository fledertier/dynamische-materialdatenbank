import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../attributes/attribute_provider.dart';
import '../../material/attribute/cards.dart';
import '../../material/attribute/default/default_cards.dart';
import '../../material/edit_mode_button.dart';
import '../../utils/miscellaneous_utils.dart';

enum SectionCategory { primary, secondary }

final sectionsProvider =
    StateProvider.family<List<CardSection>, SectionCategory>(
      (ref, arg) => throw "sectionsProvider($arg) not initialized",
    );

final draggingItemProvider = StateProvider<CardData?>((ref) => null);

final fromSectionIndexProvider = StateProvider<int?>((ref) => null);

final fromSectionCategoryProvider = StateProvider<SectionCategory?>(
  (ref) => null,
);

class DraggableSection extends ConsumerWidget {
  const DraggableSection({
    super.key,
    required this.materialId,
    required this.sectionIndex,
    required this.itemBuilder,
    required this.sectionCategory,
  });

  final String materialId;
  final int sectionIndex;
  final Widget Function(BuildContext context, CardData item) itemBuilder;
  final SectionCategory sectionCategory;

  Widget itemBuilderProxy(BuildContext context, WidgetRef ref, CardData item) {
    if (sectionCategory == SectionCategory.secondary) {
      final hasSmall = item.card.sizes.contains(CardSize.small);
      if (hasSmall) {
        final smallItem = item.copyWith(size: CardSize.small);
        return itemBuilder(context, smallItem);
      } else {
        final attribute = ref.read(attributeProvider(item.attribute));
        final defaultSmallCard = DefaultCards.values.firstWhereOrNull(
          (defaultCard) => defaultCard.type == attribute?.type.id,
        );
        if (attribute != null && defaultSmallCard != null) {
          final defaultSmallItem = item.copyWith(
            card: defaultSmallCard,
            size: CardSize.small,
          );
          return itemBuilder(context, defaultSmallItem);
        }
      }
    }
    return itemBuilder(context, item);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    final sections = ref.watch(sectionsProvider(sectionCategory));
    final section = sections[sectionIndex];
    final items = section.cards;
    // final draggingItem = ref.watch(draggingItemProvider);
    final fromSectionIndex = ref.watch(fromSectionIndexProvider);
    final fromSectionCategory = ref.watch(fromSectionCategoryProvider);
    final edit = ref.watch(editModeProvider);

    final padding =
        sectionCategory == SectionCategory.primary
            ? const EdgeInsets.all(8)
            : EdgeInsets.zero;

    final nameField = Padding(
      padding:
          sectionCategory == SectionCategory.primary
              ? const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 16)
              : const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      child: TextFormField(
        initialValue: section.nameDe,
        enabled: edit,
        style:
            sectionCategory == SectionCategory.primary
                ? textTheme.headlineMedium?.copyWith(fontFamily: 'Lexend')
                : textTheme.titleMedium?.copyWith(fontFamily: 'Lexend'),
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

    Widget nonDraggable(CardData item) {
      return Padding(
        padding: padding,
        child: itemBuilderProxy(context, ref, item),
      );
    }

    Widget draggable(CardData item) {
      final child = itemBuilderProxy(context, ref, item);
      return Draggable<CardData>(
        data: item,
        maxSimultaneousDrags: 1,
        onDragStarted: () {
          ref.read(draggingItemProvider.notifier).state = item;
          ref.read(fromSectionIndexProvider.notifier).state = sectionIndex;
          ref.read(fromSectionCategoryProvider.notifier).state =
              sectionCategory;
        },
        onDragEnd: (_) {
          ref.invalidate(draggingItemProvider);
          ref.invalidate(fromSectionIndexProvider);
        },
        feedback: Padding(
          padding: padding,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            elevation: 8,
            child: child,
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0,
          child: Padding(padding: padding, child: child),
        ),
        child: DragTarget<CardData>(
          onWillAcceptWithDetails: (details) => details.data != item,
          onAcceptWithDetails: (details) {
            final insertIndex = sections[sectionIndex].cards.indexOf(item);

            if (fromSectionCategory != null && fromSectionIndex != null) {
              ref.read(sectionsProvider(fromSectionCategory).notifier).update((
                sections,
              ) {
                final updated = [...sections];
                updated[fromSectionIndex].cards.remove(details.data);
                return updated;
              });
            }

            ref.read(sectionsProvider(sectionCategory).notifier).update((
              sections,
            ) {
              final updated = [...sections];
              updated[sectionIndex].cards.insert(insertIndex, details.data);
              return updated;
            });

            ref.invalidate(draggingItemProvider);
            ref.invalidate(fromSectionIndexProvider);
            ref.invalidate(fromSectionCategoryProvider);
          },
          builder: (context, candidateData, rejectedData) {
            if (candidateData.isEmpty) {
              return Padding(padding: padding, child: child);
            }

            bool isBefore() {
              if (fromSectionCategory != sectionCategory) {
                return true;
              }
              if (fromSectionIndex != sectionIndex) {
                return true;
              }
              final section = sections[sectionIndex];
              final index = section.cards.indexOf(item);
              final fromIndex = section.cards.indexOf(candidateData.first!);
              return index < fromIndex;
            }

            return InsertIndicator(
              isBefore: isBefore(),
              child: Padding(padding: padding, child: child),
            );
          },
        ),
      );
    }

    Widget container({bool highlighted = false}) {
      final hasName = section.nameDe?.isNotEmpty ?? false;
      return Container(
        constraints: BoxConstraints(
          maxWidth: widthByColumns(5),
          minHeight: 100,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding:
            sectionCategory == SectionCategory.primary
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                : EdgeInsets.zero,
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
                ...List.generate(items.length, (itemIndex) {
                  final item = items[itemIndex];
                  return edit ? draggable(item) : nonDraggable(item);
                }),
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
        if (fromSectionCategory == sectionCategory &&
            fromSectionIndex == sectionIndex) {
          return;
        }

        if (fromSectionCategory != null && fromSectionIndex != null) {
          ref.read(sectionsProvider(fromSectionCategory).notifier).update((
            sections,
          ) {
            final updated = [...sections];
            updated[fromSectionIndex].cards.remove(details.data);
            return updated;
          });
        }

        ref.read(sectionsProvider(sectionCategory).notifier).update((sections) {
          final updated = [...sections];
          updated[sectionIndex].cards.add(details.data);
          return updated;
        });

        ref.invalidate(draggingItemProvider);
        ref.invalidate(fromSectionIndexProvider);
        ref.invalidate(fromSectionCategoryProvider);
      },
      builder: (context, candidateData, _) {
        return container(highlighted: candidateData.isNotEmpty);
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
