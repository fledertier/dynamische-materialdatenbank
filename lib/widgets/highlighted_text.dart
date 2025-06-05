import 'package:flutter/material.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText(
    this.text, {
    super.key,
    required this.highlighted,
    this.highlightStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.caseSensitive = false,
  });

  final String text;
  final String highlighted;
  final TextStyle highlightStyle;
  final bool caseSensitive;

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: text.replaceAllMapped(
        RegExp(RegExp.escape(highlighted), caseSensitive: caseSensitive),
        (match) => '<bold>${match.group(0)}</bold>',
      ),
      tags: {'bold': StyledTextTag(style: highlightStyle)},
    );
  }
}
