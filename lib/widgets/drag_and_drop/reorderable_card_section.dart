import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_hero/local_hero.dart';

import '../../material/attribute/add_attribute_card.dart';

class CardDragController extends ChangeNotifier {
  CardDragController() : super();

  final Map<CardSection, List<CardAndWidget>> sections = {};

  set cardsAndWidgets(Map<CardSection, List<CardAndWidget>> cardsAndWidgets) {
    sections.clear();
    sections.addAll(cardsAndWidgets);
    notifyListeners();
  }

  void addCardsAndWidgets(
    CardSection section,
    List<CardAndWidget> cardsAndWidgets,
  ) {
    final values = sections.putIfAbsent(section, () => []);
    values.addAll(cardsAndWidgets);
    notifyListeners();
  }

  List<CardAndWidget> cardsAndWidgetsFor(CardSection section) {
    return sections[section] ?? [];
  }

  bool moveCard(DraggedCard source, DraggedCard destination) {
    if (source == destination) return false;

    final sourceCardsAndWidgets = cardsAndWidgetsFor(source.section);
    final destinationCardsAndWidgets = cardsAndWidgetsFor(destination.section);

    if (destinationCardsAndWidgets.contains(source.cardAndWidget) &&
        source.cardAndWidget == destination.cardAndWidget) {
      return false;
    }

    sourceCardsAndWidgets.remove(source.cardAndWidget);

    Future.delayed(Duration.zero, () {
      if (destinationCardsAndWidgets.contains(source.cardAndWidget) &&
          source.cardAndWidget == destination.cardAndWidget) {
        return false;
      }

      final destinationIndex = destinationCardsAndWidgets.indexOf(
        destination.cardAndWidget,
      );
      destinationCardsAndWidgets.insert(destinationIndex, source.cardAndWidget);

      notifyListeners();
    });

    return true;
  }
}

class CardAndWidget {
  CardAndWidget({required this.card, required this.widget});

  final CardData card;
  final Widget widget;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CardAndWidget && other.card == card;
  }

  @override
  int get hashCode => card.hashCode;

  @override
  String toString() => 'CardAndWidget(card: $card)';
}

class DraggedCard {
  DraggedCard({required this.cardAndWidget, required this.section});

  final CardAndWidget cardAndWidget;
  final CardSection section;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DraggedCard &&
        other.cardAndWidget == cardAndWidget &&
        other.section == section;
  }

  @override
  int get hashCode => cardAndWidget.hashCode ^ section.hashCode;

  @override
  String toString() =>
      'DraggedCard(cardAndWidget: $cardAndWidget, section: $section)';
}

class ReorderableCardSection extends StatefulWidget {
  const ReorderableCardSection({
    super.key,
    required this.controller,
    required this.section,
    required this.materialId,
  });

  final CardDragController controller;
  final CardSection section;
  final String materialId;

  @override
  State<ReorderableCardSection> createState() => _ReorderableCardSectionState();
}

class _ReorderableCardSectionState extends State<ReorderableCardSection> {
  List<CardAndWidget> cardsAndWidgets = [];

  @override
  void initState() {
    super.initState();

    cardsAndWidgets = widget.controller.cardsAndWidgetsFor(widget.section);

    widget.controller.addListener(() {
      setState(() {
        cardsAndWidgets = widget.controller.cardsAndWidgetsFor(widget.section);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ...cardsAndWidgets.map(buildDraggable),
        Consumer(
          builder: (context, ref, child) {
            return AddAttributeCardButton(
              materialId: widget.materialId,
              onAdded: (card) {
                addCard(card);
                // ref
                //     .read(materialServiceProvider)
                //     .updateMaterialById(widget.materialId, {
                //       Attributes.cardSections:
                //           drags.map((card) => card.toJson()).toList(),
                //     });
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildDraggable(CardAndWidget cardAndWidget) {
    final data = DraggedCard(
      cardAndWidget: cardAndWidget,
      section: widget.section,
    );
    final card = cardAndWidget.card;
    final child = cardAndWidget.widget;

    return DragTarget<DraggedCard>(
      // key: ValueKey(card),
      onWillAcceptWithDetails: (details) {
        return widget.controller.moveCard(details.data, data);
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<DraggedCard>(
          data: data,
          rootOverlay: true,
          feedback: Material(
            borderRadius: BorderRadius.circular(16),
            elevation: 8,
            child: child,
          ),
          childWhenDragging: Opacity(opacity: 0, child: child),
          child: LocalHero(enabled: false, tag: card.attribute, child: child),
        );
      },
    );
  }

  void addCard(CardData card) {
    // todo: add card to section via controller
    setState(() {});
  }
}
