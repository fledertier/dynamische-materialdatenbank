import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/list/list_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return AttributeCard(
      columns: widget.columns,
      label: AttributeLabel(attributeId: widget.attributeId),
      title: ListAttributeField(
        attributeId: widget.attributeId,
        list: list,
        isRoot: true,
        onChanged: (list) {
          final json = toJson(list, attribute.type);
          debouncer.debounce(
            duration: const Duration(milliseconds: 1000),
            onDebounce: () {
              ref
                  .read(materialProvider(widget.materialId).notifier)
                  .updateMaterial({widget.attributeId: json});
            },
          );
        },
      ),
    );
  }
}
