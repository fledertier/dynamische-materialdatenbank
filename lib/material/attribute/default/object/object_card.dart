import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../attributes/attribute_converter.dart';
import '../../../../attributes/attribute_provider.dart';
import 'object_attribute_field.dart';

class ObjectCard extends ConsumerStatefulWidget {
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
  ConsumerState<ObjectCard> createState() => _ObjectCardState();
}

class _ObjectCardState extends ConsumerState<ObjectCard> {
  final debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    final argument = AttributeArgument(
      materialId: widget.materialId,
      attributeId: widget.attributeId,
    );
    final object = ref.watch(valueProvider(argument));
    final attribute = ref.watch(attributeProvider(widget.attributeId)).value;

    if (attribute == null) {
      return SizedBox();
    }

    return AttributeCard(
      label: AttributeLabel(attributeId: widget.attributeId),
      title: ObjectAttributeField(
        attributeId: widget.attributeId,
        object: object,
        isRoot: true,
        onChanged: (object) {
          print('SAVE'); // todo: why is this not called?
          debouncer.debounce(
            duration: Duration(milliseconds: 1000),
            onDebounce: () {
              final json = toJson(object, attribute.type);
              ref
                  .read(materialProvider(widget.materialId).notifier)
                  .updateMaterial({widget.attributeId: json});
            },
          );
        },
      ),
      columns: widget.columns,
    );
  }
}
