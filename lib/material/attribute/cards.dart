import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/custom_cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/default_cards.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // ignore: unnecessary_cast because the linter is stupid
    return card as Cards;
  }
}

abstract class CardFactory {
  static Map<String, Map<CardData, Widget>> cache = {};

  static Widget getOrCreate(
    CardData data,
    String materialId, [
    CardSize? size,
  ]) {
    final cacheForMaterial = cache.putIfAbsent(materialId, () => {});
    return Consumer(
      builder: (context, ref, child) {
        final attribute = ref
            .watch(attributeProvider(AttributePath(data.attributeId)))
            .value;
        final resized = resize(data, attribute, size);

        return cacheForMaterial.putIfAbsent(
          resized,
          () => create(resized, materialId),
        );
      },
    );
  }

  static Widget create(CardData data, String materialId) {
    final card = data.card;
    return switch (card) {
      CustomCards() => CustomCardFactory.create(card, materialId, data.size),
      DefaultCards() => DefaultCardFactory.create(
        card,
        materialId,
        data.attributeId,
        data.size,
      ),
      _ => throw Exception('Unknown cards type: ${card.runtimeType}'),
    };
  }

  static CardData resize(CardData data, Attribute? attribute, CardSize? size) {
    if (size == null) return data;

    final hasSize = data.card.sizes.contains(size);
    if (hasSize) {
      return data.copyWith(size: size);
    }

    if (attribute == null) {
      return data;
    }
    final defaultCard = DefaultCards.values.firstWhereOrNull(
      (defaultCard) => defaultCard.type == attribute.type.id,
    );
    if (defaultCard == null) {
      return data;
    }
    return data.copyWith(card: defaultCard, size: size);
  }
}

class CardData {
  const CardData({
    required this.card,
    required this.attributeId,
    required this.size,
  });

  final Cards card;
  final String attributeId;
  final CardSize size;

  CardData copyWith({Cards? card, String? attributeId, CardSize? size}) {
    return CardData(
      card: card ?? this.card,
      attributeId: attributeId ?? this.attributeId,
      size: size ?? this.size,
    );
  }

  factory CardData.fromCustomCard(CustomCards card) {
    return CardData(
      card: card,
      attributeId: card.attributes.first,
      size: card.sizes.last,
    );
  }

  factory CardData.fromJson(Json json) {
    return CardData(
      card: Cards.fromName(json['card']),
      attributeId: json['attributeId'],
      size: CardSize.values.byName(json['size']),
    );
  }

  Json toJson() {
    return {'card': card.name, 'attributeId': attributeId, 'size': size.name};
  }

  @override
  String toString() {
    return 'CardData(card: $card, attributeId: $attributeId, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CardData) return false;
    return card == other.card &&
        attributeId == other.attributeId &&
        size == other.size;
  }

  @override
  int get hashCode {
    return Object.hash(card, attributeId, size);
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
      primary: List<Json>.from(
        json['primary'] ?? [],
      ).map(CardSection.fromJson).toList(),
      secondary: List<Json>.from(
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
