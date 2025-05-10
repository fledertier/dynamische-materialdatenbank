import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_attribute_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../types.dart';
import '../../../material_service.dart';
import '../../attribute_card.dart';
import '../../cards.dart';

class TextCard extends ConsumerWidget {
  const TextCard({
    super.key,
    required this.material,
    required this.attribute,
    required this.size,
    this.textStyle,
  });

  final Json material;
  final String attribute;
  final CardSize size;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AttributeCard(
      label: AttributeLabel(attribute: attribute),
      title: NumberAttributeField(
        attribute: attribute,
        value: material[attribute],
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            attribute: value,
          });
        },
      ),
    );
  }
}
