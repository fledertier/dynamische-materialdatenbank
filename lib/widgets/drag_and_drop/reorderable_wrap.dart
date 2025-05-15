import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_hero/local_hero.dart';

import '../../constants.dart';
import '../../material/attribute/add_attribute_card.dart';
import '../../material/material_service.dart';
import 'animated_draggable.dart';
import 'local_hero_overlay.dart';

class ReorderableWrap extends StatefulWidget {
  const ReorderableWrap({
    super.key,
    required this.cards,
    required this.materialId,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  final List<CardData> cards;
  final String materialId;
  final Duration animationDuration;

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
            .map((card) => CardFactory.create(card, widget.materialId))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return LocalHeroScope(
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
      createRectTween: (begin, end) {
        return RectTween(begin: begin, end: end);
      },
      child: LocalHeroOverlay(
        clip: Clip.none,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ...children.mapIndexed((index, child) {
              return makeDraggable(index);
            }),
            Consumer(
              builder: (context, ref, child) {
                return AddAttributeCardButton(
                  materialId: widget.materialId,
                  onAdded: (card) {
                    addCard(card);
                    ref
                        .read(materialServiceProvider)
                        .updateMaterialById(widget.materialId, {
                          Attributes.cards:
                              cards.map((card) => card.toJson()).toList(),
                        });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget makeDraggable(int index) {
    final data = cards.elementAtOrNull(index);
    if (data == null) {
      return children[index];
    }
    return DragTarget<CardData>(
      key: ValueKey(data),
      onWillAcceptWithDetails: (details) {
        final accept = details.data != data;
        if (accept) {
          onReorder(details.data, data);
        }
        return accept;
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedDraggable<CardData>(
          tag: data.attribute,
          data: data,
          feedbackBuilder: decorateWithShadow,
          child: children[index],
        );
      },
    );
  }

  void addCard(CardData card) {
    cards.add(card);
    final child = CardFactory.create(card, widget.materialId);
    children.add(child);
    setState(() {});
  }

  void onReorder(CardData source, CardData target) {
    final sourceIndex = cards.indexOf(source);
    final targetIndex = cards.indexOf(target);

    if (sourceIndex == targetIndex) return;

    final card = cards.removeAt(sourceIndex);
    cards.insert(targetIndex, card);

    final child = children.removeAt(sourceIndex);
    children.insert(targetIndex, child);

    setState(() {});
  }

  Widget decorateWithShadow(Widget child) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: child,
    );
  }
}
