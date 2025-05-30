import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/list/list_field.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../attributes/attribute_converter.dart';
import '../../../../attributes/attribute_type.dart';

class ListCard extends ConsumerStatefulWidget {
  const ListCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.textStyle,
    this.columns = 2,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final TextStyle? textStyle;
  final int columns;

  @override
  ConsumerState<ListCard> createState() => _ListCardState();
}

class _ListCardState extends ConsumerState<ListCard> {
  final debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    final argument = AttributeArgument(
      materialId: widget.materialId,
      attributeId: widget.attributeId,
    );
    final list = ref.watch(valueProvider(argument)) as List? ?? [];
    final attribute = ref.watch(attributeProvider(widget.attributeId)).value;

    if (attribute == null) {
      return SizedBox();
    }

    final listType = attribute.type as ListAttributeType;

    return AttributeCard(
      columns: widget.columns,
      label: AttributeLabel(attributeId: widget.attributeId),
      title: ListField(
        attributeId: widget.attributeId,
        list: list,
        onChanged: (list, update) {
          final json = toJson(list, listType);
          if (update == ListUpdateType.update) {
            updateDebounced(json);
          } else {
            updateImmediately(json);
          }
        },
      ),
    );
  }

  void updateDebounced(List json) {
    debouncer.debounce(
      duration: const Duration(milliseconds: 1000),
      onDebounce: () {
        updateImmediately(json);
      },
    );
  }

  void updateImmediately(List json) {
    ref.read(materialProvider(widget.materialId).notifier).updateMaterial({
      widget.attributeId: json,
    });
  }
}
