import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/widgets/drag_and_drop/reorderable_card_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../material/attribute/add_attribute_card.dart';
import '../../material/material_service.dart';
import '../../types.dart';

class ReorderableWrap extends StatefulWidget {
  const ReorderableWrap({
    super.key,
    required this.cards,
    required this.material,
  });

  final List<CardData> cards;
  final Json material;

  @override
  State<ReorderableWrap> createState() => _ReorderableWrapState();
}

class _ReorderableWrapState extends State<ReorderableWrap> {
  late final List<CardData> cards;
  late final List<Widget> children;

  @override
  void initState() {
    super.initState();
    cards = widget.cards;
    children =
        widget.cards
            .map((card) => CardFactory.create(card, widget.material))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableCardSection(
      material: widget.material,
      cards: cards,
      itemBuilder: (context, index) {
        return children[index];
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
        final sourceIndex = cards.indexOf(source);
        final targetIndex = cards.indexOf(target);

        if (sourceIndex == targetIndex) return;

        final card = cards.removeAt(sourceIndex);
        cards.insert(targetIndex, card);

        final child = children.removeAt(sourceIndex);
        // final newChild = CardFactory.create(card, widget.material);
        children.insert(targetIndex, child);
      },
    );
  }
}
