import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/textarea/textarea_card.dart';
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

    final type = ref.watch(attributeProvider(attributeId))?.type;
    if (type is TextAttributeType && type.multiline) {
      return TextareaCard(
        materialId: materialId,
        attributeId: attributeId,
        size: size,
        textStyle: textStyle,
      );
    }

    return AttributeCard(
      label: AttributeLabel(attribute: attributeId),
      title: TextAttributeField(
        attributeId: attributeId,
        value: value,
        onChanged: (value) {
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            attributeId: value,
          });
        },
      ),
    );
  }
}
