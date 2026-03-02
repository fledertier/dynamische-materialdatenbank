import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/providers/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_label.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/object/object_attribute_field.dart';
import 'package:dynamische_materialdatenbank/features/material/providers/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final attributePath = AttributePath(attributeId);
    final argument = AttributeArgument(
      materialId: materialId,
      attributePath: attributePath,
    );
    final object = ref.watch(valueProvider(argument));
    final attribute = ref.watch(attributeProvider(attributePath)).value;

    if (attribute == null) {
      return SizedBox();
    }

    return AttributeCard(
      label: AttributeLabel(attributeId: attributeId),
      title: ObjectAttributeField(
        attributePath: attributePath,
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
