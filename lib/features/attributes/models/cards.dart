import 'package:dynamische_materialdatenbank/features/attributes/custom/custom_cards.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/default_cards.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/shared/utils/miscellaneous_utils.dart';

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
