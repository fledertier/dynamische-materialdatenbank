import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAttributeField extends ConsumerStatefulWidget {
  const TextAttributeField({
    super.key,
    required this.attributeId,
    this.text,
    this.onChanged,
    this.textStyle,
  });

  final String attributeId;
  final TranslatableText? text;
  final ValueChanged<TranslatableText>? onChanged;
  final TextStyle? textStyle;

  @override
  ConsumerState<TextAttributeField> createState() =>
      _NumberAttributeFieldState();
}

class _NumberAttributeFieldState extends ConsumerState<TextAttributeField> {
  late final TextEditingController controller;
  late var text = widget.text ?? TranslatableText(valueDe: '');

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text?.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(widget.attributeId));
    final multiline =
        (attribute?.type as TextAttributeType?)?.multiline ?? false;

    final textTheme = TextTheme.of(context);
    final defaultTextStyle =
        multiline ? textTheme.bodySmall : textTheme.titleLarge;

    final textField = TextField(
      enabled: edit,
      style: (widget.textStyle ?? defaultTextStyle)?.copyWith(
        fontFamily: 'Lexend',
      ),
      decoration: InputDecoration.collapsed(hintText: attribute?.name),
      maxLines: multiline ? null : 1,
      controller: controller,
      onChanged: (value) {
        text = text.copyWith(valueDe: value);
        widget.onChanged?.call(text);
      },
    );

    if (multiline) {
      return textField;
    } else {
      return IntrinsicWidth(child: textField);
    }
  }
}
