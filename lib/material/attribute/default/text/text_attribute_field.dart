import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAttributeField extends ConsumerStatefulWidget {
  const TextAttributeField({
    super.key,
    required this.attribute,
    this.value,
    this.onChanged,
  });

  final String attribute;
  final String? value;
  final ValueChanged<String>? onChanged;

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
    final textTheme = TextTheme.of(context);

    final attribute = ref.watch(attributeProvider(widget.attribute));
    final edit = ref.watch(editModeProvider);

    return IntrinsicWidth(
      child: TextField(
        enabled: edit,
        style: textTheme.titleLarge?.copyWith(fontFamily: 'Lexend'),
        decoration: InputDecoration.collapsed(hintText: attribute?.name),
        controller: controller,
        onChanged: widget.onChanged,
      ),
    );
  }
}
