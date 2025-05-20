import 'package:dynamische_materialdatenbank/app/theme.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card_search.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../constants.dart';
import '../../widgets/dialog_background.dart';
import '../../widgets/drag_and_drop/draggable_section.dart';
import '../material_provider.dart';
import 'cards.dart';

class AddAndRemoveAttributeCardButton extends ConsumerWidget {
  const AddAndRemoveAttributeCardButton({
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

class AddAttributeCardDialog extends StatefulWidget {
  const AddAttributeCardDialog({
    super.key,
    required this.materialId,
    this.sizes = const {CardSize.small, CardSize.large},
    required this.onClose,
  });

  final String materialId;
  final Set<CardSize> sizes;
  final VoidCallback onClose;

  @override
  State<AddAttributeCardDialog> createState() => _AddAttributeDialogState();
}

class _AddAttributeDialogState extends State<AddAttributeCardDialog> {
  List<CardData> cards = [];

  @override
  Widget build(BuildContext context) {
    return DialogBackground(
      onDismiss: widget.onClose,
      child: ProviderScope(
        overrides: [editModeProvider.overrideWith((ref) => false)],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            SizedBox(height: 32),
            AttributeCardSearch(
              materialId: widget.materialId,
              sizes: widget.sizes,
              onSubmit: (cards) {
                setState(() {
                  this.cards = cards;
                });
              },
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(64).copyWith(top: 32),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final card in cards)
                      Builder(
                        builder: (context) {
                          final child = Material(
                            type: MaterialType.transparency,
                            child: GestureDetector(
                              onTap: () {},
                              child: AbsorbPointer(
                                child: CardFactory.create(
                                  card,
                                  exampleMaterial[Attributes.id],
                                ),
                              ),
                            ),
                          );
                          return LongPressDraggable(
                            data: card,
                            delay: Duration(milliseconds: 250),
                            onDragStarted: widget.onClose,
                            feedback: Material(
                              color: Colors.transparent,
                              elevation: 8,
                              borderRadius: BorderRadius.circular(8),
                              child: child,
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0,
                              child: child,
                            ),
                            child: child,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
