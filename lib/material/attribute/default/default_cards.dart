import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/url/url_card.dart';
import 'package:flutter/widgets.dart';

import 'boolean/boolean_card.dart';
import 'list/list_card.dart';
import 'number/number_card.dart';
import 'text/text_card.dart';

enum DefaultCards implements Cards {
  textCard(type: AttributeType.text, sizes: {CardSize.small, CardSize.large}),
  numberCard(
    type: AttributeType.number,
    sizes: {CardSize.small, CardSize.large},
  ),
  booleanCard(
    type: AttributeType.boolean,
    sizes: {CardSize.small, CardSize.large},
  ),
  urlCard(type: AttributeType.url, sizes: {CardSize.small, CardSize.large}),
  listCard(type: AttributeType.list, sizes: {CardSize.small, CardSize.large});

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
      DefaultCards.numberCard => NumberCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
      ),
      DefaultCards.booleanCard => BooleanCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
      ),
      DefaultCards.urlCard => UrlCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
      ),
      DefaultCards.listCard => ListCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
      ),
    };
  }
}
