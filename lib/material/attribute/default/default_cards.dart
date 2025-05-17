import 'package:dynamische_materialdatenbank/material/attribute/default/text/text_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/textarea/textarea_card.dart';
import 'package:flutter/widgets.dart';

import '../../../attributes/attribute_type.dart';
import '../cards.dart';
import 'number/number_card.dart';

enum DefaultCards implements Cards {
  textCard(type: AttributeType.text, sizes: {CardSize.small, CardSize.large}),
  textareaCard(
    type: AttributeType.textarea,
    sizes: {CardSize.small, CardSize.large},
  ),
  numberCard(
    type: AttributeType.number,
    sizes: {CardSize.small, CardSize.large},
  );

  const DefaultCards({required this.type, required this.sizes});

  final String type;
  @override
  final Set<CardSize> sizes;
}

abstract class DefaultCardFactory {
  static Widget create(
    DefaultCards card,
    String materialId,
    String attributeId,
    CardSize size,
  ) {
    return switch (card) {
      DefaultCards.textCard => TextCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
      ),
      DefaultCards.textareaCard => TextareaCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
      ),
      DefaultCards.numberCard => NumberCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
      ),
    };
  }
}
