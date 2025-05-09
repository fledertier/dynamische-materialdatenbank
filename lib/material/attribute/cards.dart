import 'package:dynamische_materialdatenbank/material/attribute/custom_cards.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/widgets.dart';

import '../../types.dart';
import 'default_cards.dart';

enum CardSize { small, large }

extension CardSizeComparison on CardSize {
  bool operator >(CardSize other) {
    return index > other.index;
  }

  bool operator <(CardSize other) {
    return index < other.index;
  }
}

abstract class Cards implements Enum {
  const Cards(this.sizes);

  final Set<CardSize> sizes;

  factory Cards.fromName(String name) {
    final card =
        CustomCards.values.maybeByName(name) ??
        DefaultCards.values.maybeByName(name);
    if (card == null) {
      throw Exception('Unknown card name: $name');
    }
    // ignore: unnecessary_cast
    return card as Cards;
  }
}

abstract class CardFactory {
  static Widget create(CardData data, Json material) {
    final card = data.card;
    return switch (card) {
      CustomCards() => CustomCardFactory.create(card, material, data.size),
      DefaultCards() => DefaultCardFactory.create(
        card,
        material,
        data.attribute,
        data.size,
      ),
      _ => throw Exception('Unknown cards type: ${card.runtimeType}'),
    };
  }
}

class CardData {
  const CardData({
    required this.card,
    required this.attribute,
    required this.size,
  });

  final Cards card;
  final String attribute;
  final CardSize size;

  factory CardData.fromCustomCard(CustomCards card) {
    return CardData(
      card: card,
      attribute: card.attributes.first,
      size: card.sizes.first,
    );
  }

  factory CardData.fromJson(Json json) {
    return CardData(
      card: Cards.fromName(json['card']),
      attribute: json['attribute'],
      size: CardSize.values.byName(json['size']),
    );
  }

  Json toJson() {
    return {'card': card.name, 'attribute': attribute, 'size': size.name};
  }

  @override
  String toString() {
    return 'CardData(card: $card, attribute: $attribute, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CardData) return false;
    return card == other.card &&
        attribute == other.attribute &&
        size == other.size;
  }

  @override
  int get hashCode {
    return card.hashCode ^ attribute.hashCode ^ size.hashCode;
  }
}
