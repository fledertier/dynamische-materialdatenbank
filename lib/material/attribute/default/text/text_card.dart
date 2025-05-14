import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../material_provider.dart';
import '../../../material_service.dart';
import '../../attribute_card.dart';
import '../../cards.dart';
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
    final multiline = ref.watch(attributeProvider(attributeId))?.multiline;

    final textField = TextAttributeField(
      attributeId: attributeId,
      value: value,
      onChanged: (value) {
        ref.read(materialServiceProvider).updateMaterialById(materialId, {
          attributeId: value,
        });
      },
    );

    if (multiline ?? false) {
      return AttributeCard(
        label: AttributeLabel(attribute: attributeId),
        columns: 2,
        child: textField,
      );
    } else {
      return AttributeCard(
        label: AttributeLabel(attribute: attributeId),
        title: textField,
      );
    }
  }
}
