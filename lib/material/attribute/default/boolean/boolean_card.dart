import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'boolean_attribute_field.dart';

class BooleanCard extends ConsumerWidget {
  const BooleanCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.textStyle,
    this.columns = 1,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final TextStyle? textStyle;
  final int columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final argument = AttributeArgument(
      materialId: materialId,
      attributeId: attributeId,
    );
    final boolean = ref.watch(valueProvider(argument)) as bool? ?? false;

    return AttributeCard(
      columns: columns,
      label: AttributeLabel(attribute: attributeId),
      title: BooleanAttributeField(
        attributeId: attributeId,
        boolean: boolean,
        onChanged: (boolean) {
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            attributeId: boolean,
          });
        },
        textStyle: textStyle,
      ),
    );
  }
}
