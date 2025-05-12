import 'package:dynamische_materialdatenbank/material/attribute/attribute_card_search.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants.dart';
import '../../types.dart';
import '../../utils/miscellaneous_utils.dart';
import 'cards.dart';

class AddAttributeCardButton extends StatelessWidget {
  const AddAttributeCardButton({
    super.key,
    required this.material,
    required this.onAdded,
  });

  final Json material;
  final void Function(CardData card) onAdded;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        fixedSize: Size.square(widthByColumns(1)),
      ),
      icon: Icon(Icons.add),
      onPressed: () async {
        final card = await showAddAttributeCardDialog(context);
        if (card != null) {
          onAdded(card);
        }
      },
    );
  }

  Future<CardData?> showAddAttributeCardDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AddAttributeCardDialog(material: material);
      },
    );
  }
}

class AddAttributeCardDialog extends StatefulWidget {
  const AddAttributeCardDialog({super.key, required this.material});

  final Json material;

  @override
  State<AddAttributeCardDialog> createState() => _AddAttributeDialogState();
}

class _AddAttributeDialogState extends State<AddAttributeCardDialog> {
  List<CardData> cards = [];

  final exampleMaterial = {
    Attributes.id: "example",
    Attributes.name: "Acoustic Wood Wool",
    Attributes.description:
        "BAUX Acoustic Wood Wool is a functional, natural material made from two of the world’s oldest building materials, wood and cement. The combination is simple and ingenious. Wood fiber offers excellent insulation, heat retention and sound absorption. Cement, a proven and popular building material, is the binder that provides strength, moisture resistance and fire protection. Therefore, BAUX acoustic products are versatile and durable in all climates.",
    Attributes.density: {'value': 4},
    Attributes.arealDensity: {'value': 4},
    Attributes.lightAbsorption: {'value': 56},
    Attributes.lightReflection: {'value': 37},
    Attributes.lightTransmission: {'value': 28},
    Attributes.uValue: {'value': 2},
    Attributes.wValue: {'value': 3.6},
    Attributes.fireBehaviorStandard: "C-s2,d1",
    Attributes.originCountry: ["SE"],
  };

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [editModeProvider.overrideWith((ref) => false)],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            SizedBox(height: 32),
            AttributeCardSearch(
              material: widget.material,
              onSubmit: (cards) {
                setState(() {
                  this.cards = cards;
                });
              },
            ),
            GestureDetector(
              onTap: context.pop,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(64).copyWith(top: 32),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final card in cards)
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            context.pop(card);
                          },
                          child: AbsorbPointer(
                            child: CardFactory.create(card, {
                              ...exampleMaterial,
                              ...widget.material,
                            }),
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
