import 'package:dynamische_materialdatenbank/app/theme.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/material/section/draggable_cards_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class AttributeCardButton extends ConsumerWidget {
  const AttributeCardButton({
    super.key,
    required this.materialId,
    required this.onPressed,
  });

  final String materialId;
  final VoidCallback onPressed;

  void deleteCard(WidgetRef ref, CardData card) {
    final fromSectionCategory = ref.read(fromSectionCategoryProvider);
    final fromSectionIndex = ref.read(fromSectionIndexProvider);
    if (fromSectionCategory != null && fromSectionIndex != null) {
      ref.read(sectionsProvider(fromSectionCategory).notifier).update((
        sections,
      ) {
        final updated = [...sections];
        updated[fromSectionIndex].cards.remove(card);
        ref.read(materialProvider(materialId).notifier).updateMaterial({
          Attributes.cardSections: {
            fromSectionCategory.name: updated
                .map((section) => section.toJson())
                .toList(),
          },
        });
        return updated;
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final ongoingDrag = ref.watch(draggingItemProvider) != null;

    return DragTarget<CardData>(
      onWillAcceptWithDetails: (details) => ongoingDrag,
      onAcceptWithDetails: (details) {
        deleteCard(ref, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final receivingDrag = candidateData.isNotEmpty;
        return Material(
          borderRadius: BorderRadius.circular(ongoingDrag ? 50 : 32),
          color: ongoingDrag
              ? receivingDrag
                    ? colorScheme.errorFixedDim
                    : colorScheme.surfaceContainerHighest
              : colorScheme.primaryContainer,
          elevation: 8,
          child: InkWell(
            borderRadius: BorderRadius.circular(ongoingDrag ? 50 : 32),
            onTap: onPressed,
            child: AnimatedSize(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: SizedBox(
                width: ongoingDrag ? 300 : 100,
                height: ongoingDrag ? 80 : 100,
                child: Center(
                  child: ongoingDrag
                      ? Icon(
                          Symbols.delete,
                          color: ongoingDrag && receivingDrag
                              ? colorScheme.onErrorFixedDim
                              : colorScheme.onSurface,
                        )
                      : Icon(Icons.add, color: colorScheme.onPrimaryContainer),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
