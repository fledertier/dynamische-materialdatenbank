import 'package:flutter/foundation.dart';

import '../../material/attribute/cards.dart';

class CardsNotifier extends ValueNotifier<List<CardData>> {
  CardsNotifier(List<CardData>? cards) : super(cards ?? <CardData>[]);

  List<CardData> get cards => value;

  set cards(List<CardData> cards) {
    value = cards;
  }

  void addCards(List<CardData> cards) {
    value = [...value, ...cards];
  }

  void moveCard(CardData card, CardData beforeCard) {
    final index = value.indexOf(card);
    final beforeIndex = value.indexOf(beforeCard);
    value.removeAt(index);
    value.insert(beforeIndex, card);
    notifyListeners();
  }

  void swapCards(CardData card, CardData withCard) {
    final index1 = value.indexOf(card);
    final index2 = value.indexOf(withCard);
    value[index1] = withCard;
    value[index2] = card;
    notifyListeners();
  }

  void removeCard(CardData card) {
    value.remove(card);
    notifyListeners();
  }
}
