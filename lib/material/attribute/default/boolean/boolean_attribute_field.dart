import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooleanAttributeField extends ConsumerWidget {
  const BooleanAttributeField({
    super.key,
    required this.attributeId,
    required this.boolean,
    this.onChanged,
    this.textStyle,
  });

  final String attributeId;
  final bool boolean;
  final ValueChanged<bool>? onChanged;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);

    final defaultBooleanStyle = TextTheme.of(context).titleLarge;
    final effectiveTextStyle = (textStyle ?? defaultBooleanStyle)?.copyWith(
      fontFamily: 'Lexend',
    );

    final text = boolean ? "Ja" : "Nein";

    final textField = TextButton(
      onPressed: edit ? () => onChanged?.call(!boolean) : null,
      child: Text(text, style: effectiveTextStyle),
    );

    return textField;
  }
}
