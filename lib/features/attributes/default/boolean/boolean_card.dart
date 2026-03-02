import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_label.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/boolean/boolean.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/boolean/boolean_attribute_field.dart';
import 'package:dynamische_materialdatenbank/features/material/providers/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      attributePath: AttributePath(attributeId),
    );
    final boolean =
        ref.watch(valueProvider(argument)) as Boolean? ?? Boolean(value: false);

    return AttributeCard(
      columns: columns,
      label: AttributeLabel(attributeId: attributeId),
      title: BooleanAttributeField(
        attributeId: attributeId,
        boolean: boolean,
        onChanged: (boolean) {
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            attributeId: boolean.toJson(),
          });
        },
        textStyle: textStyle,
      ),
    );
  }
}
