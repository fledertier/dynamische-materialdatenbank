import 'package:dynamische_materialdatenbank/material/attribute/custom/custom_cards.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/widgets.dart';

import '../../types.dart';
import 'default/default_cards.dart';

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
  static Map<String, Map<CardData, Widget>> cache = {};

  static Widget getOrCreate(CardData data, String materialId) {
    final cacheForMaterial = cache.putIfAbsent(materialId, () => {});
    return cacheForMaterial.putIfAbsent(data, () => create(data, materialId));
  }

  static Widget create(CardData data, String materialId) {
    final card = data.card;
    return switch (card) {
      CustomCards() => CustomCardFactory.create(card, materialId, data.size),
      DefaultCards() => DefaultCardFactory.create(
        card,
        materialId,
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

class CardSection {
  const CardSection({this.nameDe, this.nameEn, required this.cards});

  final String? nameDe;
  final String? nameEn;
  final List<CardData> cards;

  factory CardSection.fromJson(Json json) {
    return CardSection(
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      cards: List<Json>.from(json['cards']).map(CardData.fromJson).toList(),
    );
  }

  Json toJson() {
    return {
      'nameDe': nameDe,
      'nameEn': nameEn,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }

  CardSection copyWith({
    String? nameDe,
    String? nameEn,
    List<CardData>? cards,
  }) {
    return CardSection(
      nameDe: nameDe ?? this.nameDe,
      nameEn: nameEn ?? this.nameEn,
      cards: cards ?? this.cards,
    );
  }
}

class CardSections {
  const CardSections({required this.primary, required this.secondary});

  final List<CardSection> primary;
  final List<CardSection> secondary;

  factory CardSections.fromJson(Json json) {
    return CardSections(
      primary:
          List<Json>.from(
            json['primary'] ?? [],
          ).map(CardSection.fromJson).toList(),
      secondary:
          List<Json>.from(
            json['secondary'] ?? [],
          ).map(CardSection.fromJson).toList(),
    );
  }

  Json toJson() {
    return {
      'primary': primary.map((section) => section.toJson()).toList(),
      'secondary': secondary.map((section) => section.toJson()).toList(),
    };
  }

  Set<CardData> get allCards {
    return {
      ...primary.expand((section) => section.cards),
      ...secondary.expand((section) => section.cards),
    };
  }
}
