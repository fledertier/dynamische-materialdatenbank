import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_data.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_section.dart';

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
