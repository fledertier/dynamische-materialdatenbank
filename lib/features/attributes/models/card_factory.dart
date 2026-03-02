import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/custom_cards.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/default_cards.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_data.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/features/attributes/providers/attribute_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
