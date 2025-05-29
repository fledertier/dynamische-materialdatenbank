import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../debouncer.dart';
import 'text_attribute_field.dart';

class TextCard extends ConsumerStatefulWidget {
  const TextCard({
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
  ConsumerState<TextCard> createState() => _TextCardState();
}

class _TextCardState extends ConsumerState<TextCard> {
  final debounce = Debouncer(delay: const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    final text =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: widget.materialId,
                  attributeId: widget.attributeId,
                ),
              ),
            )
            as TranslatableText? ??
        TranslatableText();

    return AttributeCard(
      columns: widget.columns,
      label: AttributeLabel(attributeId: widget.attributeId),
      title: TextAttributeField(
        attributeId: widget.attributeId,
        text: text,
        onChanged: (text) {
          debounce(() {
            ref
                .read(materialProvider(widget.materialId).notifier)
                .updateMaterial({widget.attributeId: text.toJson()});
          });
        },
        textStyle: widget.textStyle,
      ),
    );
  }
}
