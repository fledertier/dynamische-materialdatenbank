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

    final text = Text(boolean ? "Ja" : "Nein", style: effectiveTextStyle);

    late final segmentedButton = SegmentedButton(
      selected: {boolean},
      segments: [
        ButtonSegment(value: true, label: Text("Ja")),
        ButtonSegment(value: false, label: Text("Nein")),
      ],
      onSelectionChanged: (selection) {
        onChanged?.call(selection.first);
      },
      showSelectedIcon: false, // there was not enough space
    );

    return edit ? segmentedButton : text;
  }
}
