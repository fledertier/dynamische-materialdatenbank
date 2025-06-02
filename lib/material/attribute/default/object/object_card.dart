import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../attributes/attribute_converter.dart';
import '../../../../attributes/attribute_provider.dart';
import 'object_attribute_field.dart';

class ObjectCard extends ConsumerWidget {
  const ObjectCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.columns = 2,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final int columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final argument = AttributeArgument(
      materialId: materialId,
      attributeId: attributeId,
    );
    final object = ref.watch(valueProvider(argument));
    final attribute = ref.watch(attributeProvider(attributeId)).value;

    if (attribute == null) {
      return SizedBox();
    }

    return AttributeCard(
      label: AttributeLabel(attributeId: attributeId),
      title: ObjectAttributeField(
        attributeId: attributeId,
        object: object,
        isRoot: true,
        onSave: (object) {
          final json = toJson(object, attribute.type);
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            attributeId: json,
          });
        },
      ),
      columns: columns,
    );
  }
}
