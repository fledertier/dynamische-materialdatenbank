import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../debouncer.dart';
import 'boolean_attribute_field.dart';

class BooleanCard extends ConsumerStatefulWidget {
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
  ConsumerState<BooleanCard> createState() => _BooleanCardState();
}

class _BooleanCardState extends ConsumerState<BooleanCard> {
  final debounce = Debouncer(delay: const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    final argument = AttributeArgument(
      materialId: widget.materialId,
      attributeId: widget.attributeId,
    );
    final boolean = ref.watch(valueProvider(argument)) as bool? ?? false;

    return AttributeCard(
      columns: widget.columns,
      label: AttributeLabel(attribute: widget.attributeId),
      title: BooleanAttributeField(
        attributeId: widget.attributeId,
        boolean: boolean,
        onChanged: (boolean) {
          debounce(() {
            ref
                .read(materialProvider(widget.materialId).notifier)
                .updateMaterial({widget.attributeId: boolean});
          });
        },
        textStyle: widget.textStyle,
      ),
    );
  }
}
