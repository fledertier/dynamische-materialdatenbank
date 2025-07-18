import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/localization/language_button.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAttributeField extends ConsumerWidget {
  const TextAttributeField({
    super.key,
    required this.attributePath,
    required this.text,
    this.onChanged,
    this.textStyle,
  });

  final AttributePath attributePath;
  final TranslatableText text;
  final ValueChanged<TranslatableText>? onChanged;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final language = ref.watch(languageProvider);
    final attribute = ref.watch(attributeProvider(attributePath)).value;

    final value =
        isTranslatable(attribute) ? text.resolve(language) : text.value;
    final otherLanguageValue =
        language == Language.en ? text.valueDe : text.valueEn;

    final url = Uri.tryParse(value ?? '');
    final isUrl = url != null && url.isAbsolute;

    final defaultTextStyle =
        isMultiline(attribute) || isUrl
            ? TextTheme.of(context).bodySmall
            : TextTheme.of(context).titleLarge;

    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isUrl) Favicon(url.toString()),
        Expanded(
          child: TextFormField(
            key: ValueKey(value),
            initialValue: value,
            enabled: edit,
            style: (textStyle ?? defaultTextStyle)?.copyWith(
              fontFamily: 'Lexend',
            ),
            decoration: InputDecoration.collapsed(
              hintText: otherLanguageValue ?? attribute?.name ?? 'Text',
            ),
            maxLines: isMultiline(attribute) ? null : 1,
            onChanged: (value) {
              final newText = text.copyWithLanguage(language, value);
              onChanged?.call(newText);
            },
          ),
        ),
      ],
    );
  }
}
