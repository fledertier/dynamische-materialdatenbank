import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../edit_mode_button.dart';
import '../../../material_provider.dart';
import '../../attribute_card.dart';
import '../../cards.dart';

class TextareaCard extends ConsumerStatefulWidget {
  const TextareaCard({
    super.key,
    required this.materialId,
    required this.attributeId,
    required this.size,
    this.textStyle,
  });

  final String materialId;
  final String attributeId;
  final CardSize size;
  final TextStyle? textStyle;

  @override
  ConsumerState<TextareaCard> createState() => _TextAreaCardState();
}

class _TextAreaCardState extends ConsumerState<TextareaCard> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final value = ref.read(
      materialAttributeValueProvider(
        AttributeArgument(
          materialId: widget.materialId,
          attributeId: widget.attributeId,
        ),
      ),
    );
    controller = TextEditingController(text: value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final defaultTextStyle = textTheme.bodySmall!.copyWith(
      fontFamily: 'Lexend',
    );

    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(widget.attributeId));

    return AttributeCard(
      label: AttributeLabel(attribute: widget.attributeId),
      columns: 2,
      child: TextField(
        enabled: edit,
        style: widget.textStyle ?? defaultTextStyle,
        decoration: InputDecoration.collapsed(hintText: attribute?.name),
        maxLines: null,
        controller: controller,
        onChanged: (value) {
          ref.read(materialProvider(widget.materialId).notifier).updateMaterial(
            {widget.attributeId: value},
          );
        },
      ),
    );
  }
}
