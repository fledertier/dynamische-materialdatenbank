import 'package:dynamische_materialdatenbank/material/attribute/text/text_card.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/attribute_type.dart';
import '../../types.dart';
import 'cards.dart';

enum DefaultCards implements Cards {
  textCard(type: AttributeType.text, sizes: {CardSize.small, CardSize.large});

  const DefaultCards({required this.type, required this.sizes});

  final AttributeType type;
  @override
  final Set<CardSize> sizes;
}

abstract class DefaultCardFactory {
  static Widget create(
    DefaultCards card,
    Json material,
    String attribute,
    CardSize size,
  ) {
    return switch (card) {
      DefaultCards.textCard => TextCard(
        material: material,
        attribute: attribute,
        size: size,
      ),
    };
  }
}
