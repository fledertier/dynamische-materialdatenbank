import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/widgets/drag_and_drop/cards_notifier.dart';
import 'package:dynamische_materialdatenbank/widgets/drag_and_drop/reorderable_card_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../material/attribute/add_attribute_card.dart';
import '../../material/material_service.dart';
import '../../types.dart';

class Dings extends StatefulWidget {
  const Dings({super.key, required this.cards, required this.material});

  final List<CardData> cards;
  final Json material;

  @override
  State<Dings> createState() => _DingsState();
}

class _DingsState extends State<Dings> {
  late final notifier = CardsNotifier(widget.cards);
  late final Map<CardData, Widget> children = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableCardSection(
      material: widget.material,
      cards: notifier.cards,
      itemBuilder: (context, index) {
        final card = notifier.cards[index];
        return CardFactory.create(card, widget.material);
        // return children.putIfAbsent(
        //   card,
        //   () => CardFactory.create(card, widget.material),
        // );
      },
      trailing: Consumer(
        builder: (context, ref, child) {
          return AddAttributeCardButton(
            material: widget.material,
            onAdded: (card) {
              ref.read(materialServiceProvider).updateMaterial(
                widget.material,
                {
                  Attributes.cards: [
                    ...?widget.material[Attributes.cards],
                    card.toJson(),
                  ],
                },
              );
            },
          );
        },
      ),
      onReorder: (source, target) {
        notifier.moveCard(source, target);
      },
    );
  }
}
