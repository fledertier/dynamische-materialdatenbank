import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAttributeField extends ConsumerStatefulWidget {
  const TextAttributeField({
    super.key,
    required this.attributeId,
    this.value,
    this.onChanged,
    this.textStyle,
  });

  final String attributeId;
  final String? value;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;

  @override
  ConsumerState<TextAttributeField> createState() =>
      _NumberAttributeFieldState();
}

class _NumberAttributeFieldState extends ConsumerState<TextAttributeField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
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
    final multiline = attribute?.multiline ?? false;

    final textTheme = TextTheme.of(context);
    final textStyle = (multiline ? textTheme.bodySmall : textTheme.titleLarge)!
        .copyWith(fontFamily: 'Lexend');

    return IntrinsicWidth(
      child: TextField(
        enabled: edit,
        style: widget.textStyle ?? textStyle,
        decoration: InputDecoration.collapsed(hintText: attribute?.name),
        maxLines: multiline ? null : 1,
        controller: controller,
        onChanged: widget.onChanged,
      ),
    );
  }
}
