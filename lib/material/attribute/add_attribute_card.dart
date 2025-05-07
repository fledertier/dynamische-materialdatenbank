import 'package:dynamische_materialdatenbank/material/attribute/attribute_card_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'attribute_card_factory.dart';
import 'attribute_cards.dart';

class AddAttributeCardButton extends StatelessWidget {
  const AddAttributeCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Padding(padding: const EdgeInsets.all(32), child: Icon(Icons.add)),
      onPressed: () {
        showAddAttributeCardDialog(context);
      },
    );
  }
}

void showAddAttributeCardDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AddAttributeCardDialog();
    },
  );
}

class AddAttributeCardDialog extends StatefulWidget {
  const AddAttributeCardDialog({super.key});

  @override
  State<AddAttributeCardDialog> createState() => _AddAttributeDialogState();
}

class _AddAttributeDialogState extends State<AddAttributeCardDialog> {
  Set<AttributeCards> attributeCards = AttributeCards.values.toSet();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          SizedBox(height: 32),
          AttributeCardSearch(
            onSubmit: (attributeCards) {
              setState(() {
                this.attributeCards = attributeCards;
              });
            },
          ),
          Flexible(
            child: GestureDetector(
              onTap: context.pop,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(64).copyWith(top: 32),
                hitTestBehavior: HitTestBehavior.translucent,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final card in attributeCards)
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            context.pop(card);
                          },
                          child: AbsorbPointer(
                            child: AttributeCardFactory.create(card, {}),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
