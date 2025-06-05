import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/material/section/draggable_card.dart';
import 'package:dynamische_materialdatenbank/material/section/draggable_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SectionCategory { primary, secondary }

final sectionsProvider =
    StateProvider.family<List<CardSection>, SectionCategory>(
      (ref, arg) => throw 'sectionsProvider($arg) not initialized',
    );

final draggingItemProvider = StateProvider<CardData?>((ref) => null);

final fromSectionIndexProvider = StateProvider<int?>((ref) => null);

final fromSectionCategoryProvider = StateProvider<SectionCategory?>(
  (ref) => null,
);

class DraggableCardsBuilder extends ConsumerWidget {
  const DraggableCardsBuilder({
    super.key,
    required this.materialId,
    required this.sectionIndex,
    required this.itemBuilder,
    required this.containerBuilder,
    required this.sectionCategory,
    required this.padding,
  });

  final String materialId;
  final int sectionIndex;
  final Widget Function(BuildContext context, CardData item) itemBuilder;
  final Widget Function(
    BuildContext context,
    Widget Function(int index) itemBuilder,
    bool highlighted,
  )
  containerBuilder;
  final SectionCategory sectionCategory;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(sectionsProvider(sectionCategory));
    final section = sections[sectionIndex];
    final items = section.cards;
    final fromSectionIndex = ref.watch(fromSectionIndexProvider);
    final fromSectionCategory = ref.watch(fromSectionCategoryProvider);

    Widget draggableBuilder(int index) {
      final item = items[index];
      final child = itemBuilder(context, item);
      return DraggableCard(
        data: item,
        padding: padding,
        onDragStarted: () {
          ref.read(draggingItemProvider.notifier).state = item;
          ref.read(fromSectionIndexProvider.notifier).state = sectionIndex;
          ref.read(fromSectionCategoryProvider.notifier).state =
              sectionCategory;
        },
        onDragEnd: () {
          ref.invalidate(draggingItemProvider);
          ref.invalidate(fromSectionIndexProvider);
        },
        child: DragTarget<CardData>(
          onWillAcceptWithDetails: (details) => details.data != item,
          onAcceptWithDetails: (details) {
            final insertIndex = sections[sectionIndex].cards.indexOf(item);

            final sectionsJson = Json();

            if (fromSectionCategory != null && fromSectionIndex != null) {
              ref.read(sectionsProvider(fromSectionCategory).notifier).update((
                sections,
              ) {
                final updated = [...sections];
                updated[fromSectionIndex].cards.remove(details.data);
                sectionsJson[fromSectionCategory.name] =
                    updated.map((section) => section.toJson()).toList();
                return updated;
              });
            }

            ref.read(sectionsProvider(sectionCategory).notifier).update((
              sections,
            ) {
              final updated = [...sections];
              updated[sectionIndex].cards.insert(insertIndex, details.data);
              sectionsJson[sectionCategory.name] =
                  updated.map((section) => section.toJson()).toList();
              return updated;
            });

            ref.read(materialProvider(materialId).notifier).updateMaterial({
              Attributes.cardSections: sectionsJson,
            });

            ref.invalidate(draggingItemProvider);
            ref.invalidate(fromSectionIndexProvider);
            ref.invalidate(fromSectionCategoryProvider);
          },
          builder: (context, candidateData, rejectedData) {
            if (candidateData.isEmpty) {
              return child;
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

            return InsertIndicator(isBefore: isBefore(), child: child);
          },
        ),
      );
    }

    return DragTarget<CardData>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        if (fromSectionCategory == sectionCategory &&
            fromSectionIndex == sectionIndex) {
          return;
        }

        final sectionsJson = Json();

        if (fromSectionCategory != null && fromSectionIndex != null) {
          ref.read(sectionsProvider(fromSectionCategory).notifier).update((
            sections,
          ) {
            final updated = [...sections];
            updated[fromSectionIndex].cards.remove(details.data);
            sectionsJson[fromSectionCategory.name] =
                updated.map((section) => section.toJson()).toList();
            return updated;
          });
        }

        ref.read(sectionsProvider(sectionCategory).notifier).update((sections) {
          final updated = [...sections];
          updated[sectionIndex].cards.add(details.data);
          sectionsJson[sectionCategory.name] =
              updated.map((section) => section.toJson()).toList();
          return updated;
        });

        ref.read(materialProvider(materialId).notifier).updateMaterial({
          Attributes.cardSections: sectionsJson,
        });

        ref.invalidate(draggingItemProvider);
        ref.invalidate(fromSectionIndexProvider);
        ref.invalidate(fromSectionCategoryProvider);
      },
      builder: (context, candidateData, _) {
        final highlighted = candidateData.isNotEmpty;
        return containerBuilder(context, draggableBuilder, highlighted);
      },
    );
  }
}
