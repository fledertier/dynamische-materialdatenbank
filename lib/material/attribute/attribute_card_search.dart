import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_search.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/custom_cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/default_cards.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributeCardSearch extends ConsumerStatefulWidget {
  const AttributeCardSearch({
    super.key,
    required this.materialId,
    this.sizes = const {CardSize.large, CardSize.small},
    required this.onSubmit,
  });

  final String materialId;
  final Set<CardSize> sizes;
  final void Function(List<CardData>) onSubmit;

  @override
  ConsumerState<AttributeCardSearch> createState() =>
      _AttributeCardSearchState();
}

class _AttributeCardSearchState extends ConsumerState<AttributeCardSearch> {
  @override
  Widget build(BuildContext context) {
    return AttributeSearch(
      autofocus: true,
      onSubmit: (attributes) {
        final cards = findCardsForAttributes(attributes, widget.sizes);
        final unselectedCards = cards.difference(selectedCards).toList();
        widget.onSubmit.call(unselectedCards);
      },
    );
  }

  Set<CardData> get selectedCards {
    final value = ref.read(
      jsonValueProvider(
        AttributeArgument(
          materialId: widget.materialId,
          attributePath: AttributePath(Attributes.cardSections),
        ),
      ),
    );
    if (value == null) {
      return {};
    }
    return CardSections.fromJson(value).allCards;
  }
}

Set<CardData> findCardsForAttributes(
  List<Attribute> attributes,
  Set<CardSize> sizes,
) {
  return attributes
      .expand((attribute) => findCardsForAttribute(attribute, sizes))
      .toSet();
}

Set<CardData> findCardsForAttribute(Attribute attribute, Set<CardSize> sizes) {
  return _findCardsForAttribute(attribute)
      .expand(
        (card) => card.sizes.intersection(sizes).map((size) {
          return CardData(card: card, attributeId: attribute.id, size: size);
        }),
      )
      .toSet();
}

Iterable<Cards> _findCardsForAttribute(Attribute attribute) {
  return [
    ..._findCardsByAttributeId(attribute.id),
    ..._findCardsByAttributeType(attribute.type),
  ];
}

Iterable<CustomCards> _findCardsByAttributeId(String attribute) {
  return CustomCards.values.where(
    (card) => card.attributes.contains(attribute),
  );
}

Iterable<DefaultCards> _findCardsByAttributeType(AttributeType type) {
  return DefaultCards.values.where((card) => card.type == type.id);
}
