import 'package:flutter/material.dart';

import '../../attributes/attribute.dart';
import '../../attributes/attribute_type.dart';
import 'attribute_cards.dart';
import 'attribute_search.dart';

class AttributeCardSearch extends StatefulWidget {
  const AttributeCardSearch({super.key, required this.onSubmit});

  final void Function(Set<AttributeCards>) onSubmit;

  @override
  State<AttributeCardSearch> createState() => _AttributeCardSearchState();
}

class _AttributeCardSearchState extends State<AttributeCardSearch> {
  @override
  Widget build(BuildContext context) {
    return AttributeSearch(
      autofocus: true,
      onSubmit: (attributes) {
        final attributeCards = findAttributeCardsForAttributes(attributes);
        widget.onSubmit.call(attributeCards);
      },
    );
  }
}

Set<AttributeCards> findAttributeCardsForAttributes(
  List<Attribute> attributes,
) {
  return attributes.expand(findAttributeCardsForAttribute).toSet();
}

Set<AttributeCards> findAttributeCardsForAttribute(Attribute attribute) {
  return {
    ..._findAttributeCardsByAttributeId(attribute.id),
    ..._findAttributeCardsByAttributeType(attribute.type),
  };
}

Set<AttributeCards> _findAttributeCardsByAttributeId(String attribute) {
  return AttributeCards.values
      .where((card) => card.attributes.contains(attribute))
      .toSet();
}

Set<AttributeCards> _findAttributeCardsByAttributeType(AttributeType type) {
  return switch (type) {
    // AttributeType.text => [AttributeCards.textCard],
    // AttributeType.number => [AttributeCards.numberCard],
    _ => {},
  };
}
