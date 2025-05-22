import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'text_attribute_field.dart';

class TextCard extends ConsumerWidget {
  const TextCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.textStyle,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      materialAttributeValueProvider(
        AttributeArgument(materialId: materialId, attributeId: attributeId),
      ),
    );
    final text = value != null ? TranslatableText.fromJson(value) : null;

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(attribute: attributeId),
      title: TextAttributeField(
        attributeId: attributeId,
        text: text,
        onChanged: (text) {
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            attributeId: text.toJson(),
          });
        },
        textStyle: textStyle,
      ),
    );
  }
}
