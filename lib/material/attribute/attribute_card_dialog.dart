import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card_search.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:dynamische_materialdatenbank/material/section/draggable_card.dart';
import 'package:dynamische_materialdatenbank/widgets/dialog_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributeCardDialog extends ConsumerStatefulWidget {
  const AttributeCardDialog({
    super.key,
    required this.materialId,
    this.sizes = const {CardSize.small, CardSize.large},
    required this.onClose,
  });

  final String materialId;
  final Set<CardSize> sizes;
  final VoidCallback onClose;

  @override
  ConsumerState<AttributeCardDialog> createState() =>
      _AttributeCardDialogState();
}

class _AttributeCardDialogState extends ConsumerState<AttributeCardDialog> {
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
                  children: [
                    for (final card in cards)
                      DraggableCard(
                        data: card,
                        onDragStarted: widget.onClose,
                        child: GestureDetector(
                          onTap: () {},
                          child: AbsorbPointer(
                            child: CardFactory.create(
                              card,
                              exampleMaterial[Attributes.id],
                            ),
                          ),
                        ),
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
