import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/language_button.dart';

class TextAttributeField extends ConsumerWidget {
  const TextAttributeField({
    super.key,
    required this.attributeId,
    required this.text,
    this.onChanged,
    this.textStyle,
  });

  final String attributeId;
  final TranslatableText text;
  final ValueChanged<TranslatableText>? onChanged;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final language = ref.watch(languageProvider);
    final attribute = ref.watch(attributeProvider(attributeId)).value;
    final multiline =
        (attribute?.type as TextAttributeType?)?.multiline ?? false;

    final textTheme = TextTheme.of(context);
    final defaultTextStyle =
        multiline ? textTheme.bodySmall : textTheme.titleLarge;

    final otherLanguageText =
        language == Language.en ? text.valueDe : text.valueEn;

    return TextFormField(
      key: ValueKey(text.resolve(language)),
      initialValue: text.resolve(language),
      enabled: edit,
      style: (textStyle ?? defaultTextStyle)?.copyWith(fontFamily: 'Lexend'),
      decoration: InputDecoration.collapsed(
        hintText: otherLanguageText ?? attribute?.name,
      ),
      maxLines: multiline ? null : 1,
      onChanged: (value) {
        final newText = text.copyWithLanguage(language, value);
        onChanged?.call(newText);
      },
    );
  }
}
