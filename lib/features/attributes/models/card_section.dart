import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_data.dart';

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
