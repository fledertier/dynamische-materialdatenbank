import 'package:dynamische_materialdatenbank/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../widgets/drag_and_drop/draggable_section.dart';
import 'cards.dart';

class AttributeCardButton extends ConsumerWidget {
  const AttributeCardButton({
    super.key,
    required this.materialId,
    required this.onAdd,
    required this.onDelete,
  });

  final String materialId;
  final VoidCallback onAdd;
  final void Function(CardData card) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final ongoingDrag = ref.watch(draggingItemProvider) != null;

    return DragTarget<CardData>(
      onWillAcceptWithDetails: (details) => ongoingDrag,
      onAcceptWithDetails: (details) {
        onDelete(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final receivingDrag = candidateData.isNotEmpty;
        return Material(
          borderRadius: BorderRadius.circular(ongoingDrag ? 50 : 32),
          color:
              ongoingDrag
                  ? receivingDrag
                      ? colorScheme.errorFixedDim
                      : colorScheme.surfaceContainerHighest
                  : colorScheme.primaryContainer,
          elevation: 8,
          child: InkWell(
            borderRadius: BorderRadius.circular(ongoingDrag ? 50 : 32),
            onTap: onAdd,
            child: AnimatedSize(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: SizedBox(
                width: ongoingDrag ? 300 : 100,
                height: ongoingDrag ? 80 : 100,
                child: Center(
                  child:
                      ongoingDrag
                          ? Icon(
                            Symbols.delete,
                            color:
                                ongoingDrag && receivingDrag
                                    ? colorScheme.onErrorFixedDim
                                    : colorScheme.onSurface,
                          )
                          : Icon(
                            Icons.add,
                            color: colorScheme.onPrimaryContainer,
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
