import 'package:dynamische_materialdatenbank/features/attributes/custom/custom_cards.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/cards.dart';

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
