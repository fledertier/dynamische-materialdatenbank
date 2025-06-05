import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/tags_controller.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/tags_field.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/text_or_tag.dart';
import 'package:flutter/material.dart';

class TagsEditingController<T> extends TextEditingController {
  static final placeholder = String.fromCharCode(
    PlaceholderSpan.placeholderCodeUnit,
  );

  TagsEditingController({
    required this.controller,
    required this.tagBuilder,
    required this.textExtractor,
  }) : super(text: placeholder * (controller.tags.length)) {
    controller.addListener(() {
      _updateTags();
    });
  }

  final TagsController<T> controller;
  final TagBuilder<T> tagBuilder;
  final TextExtractor<T> textExtractor;

  @override
  set value(TextEditingValue value) {
    super.value = value;
    _updateTags();
  }

  @override
  void clear() {
    controller.clear();
    super.clear();
  }

  String composingText() {
    return composingRange().textInside(text);
  }

  TextRange composingRange() {
    if (text.isEmpty) {
      return TextRange(start: 0, end: 0);
    }
    if (selection.isCollapsed) {
      return _expandSelection(text, selection);
    }
    return selection;
  }

  /// expands the selection to include the current tag or incomplete tag with trailing commas and whitespace
  TextRange _expandSelection(String text, TextSelection selection) {
    final segmentPattern = RegExp('$placeholder|[^,$placeholder]+[,\\s]*');
    final segments = segmentPattern.allMatches(text);
    final segment = segments.firstWhereOrNull(
      (segment) => segment.range.contains(selection.start - 1),
    );
    return segment?.range ?? selection;
  }

  String selectionAsPlainText() {
    final textBefore = selection.textBefore(text);
    final textInside = selection.textInside(text);
    final segmentPattern = RegExp('$placeholder|[^,$placeholder]+');
    final segments = segmentPattern.allMatches(textInside);
    var index = textBefore.count(placeholder);

    String? asPlainText(RegExpMatch segment) {
      if (segment.text == placeholder) {
        final tag = controller.tags.elementAtOrNull(index++);
        return tag != null ? textExtractor(tag) : null;
      } else {
        return segment.text;
      }
    }

    return segments
        .map((segment) => asPlainText(segment))
        .where((tag) => tag != null && tag.trim().isNotEmpty)
        .join(', ');
  }

  String _previousText = '';
  TextSelection? _previousSelection;

  void _updateTags() {
    if (_previousSelection != null) {
      final int currentNumber = text.count(placeholder);
      final int previousNumber = _previousText.count(placeholder);

      final int cursorEnd = _previousSelection!.extentOffset;
      final int cursorStart = _previousSelection!.baseOffset;

      int indexOf(int offset) {
        final textBefore = _previousText.substring(0, offset);
        return textBefore.count(placeholder);
      }

      // If the current number and the previous number of replacements are different,
      // then the user has deleted the InputChip using the keyboard. We need to be sure
      // also that the current number of replacements is different from the input chip
      // to avoid double-deletion.
      if (currentNumber < previousNumber &&
          currentNumber != controller.tags.length) {
        if (cursorStart == cursorEnd) {
          controller.removeAt(indexOf(cursorStart) - 1);
        } else {
          if (cursorStart > cursorEnd) {
            controller.removeRange(indexOf(cursorEnd), indexOf(cursorStart));
          } else {
            controller.removeRange(indexOf(cursorStart), indexOf(cursorEnd));
          }
        }
        notifyListeners();
      }
    }

    _previousText = text;
    _previousSelection = selection;
  }

  void insertText(String text, TextRange range) {
    insert(TextOrTag.text(text), range);
  }

  void insertTag(T tag, TextRange range) {
    insert(TextOrTag.tag(tag), range);
  }

  void insert(TextOrTag<T> textOrTag, TextRange range) {
    if (!range.isValid) return;
    final textInside = range.textInside(text);
    final textBefore = range.textBefore(text);
    final textOrPlaceholder = textOrTag.isText ? textOrTag.text : placeholder;

    if (range.isCollapsed) {
      if (controller.maxNumberOfTagsReached()) {
        return;
      }

      // could be simplified further by performing the insert as a replace
      if (textOrTag.isTag) {
        final insertAt = (textBefore + textInside).count(placeholder);
        controller.insert(insertAt, textOrTag.tag);
      }
      value = TextEditingValue(
        text: text.insert(range.end, textOrPlaceholder),
        selection: TextSelection.collapsed(
          offset: range.end + textOrPlaceholder.length,
        ),
      );
    } else {
      final replaceAmount = textInside.count(placeholder);
      final replaceAt = textBefore.count(placeholder);

      if (controller.maxNumberOfTagsReached(replaceAmount)) {
        return;
      }

      controller.replaceRange(
        replaceAt,
        replaceAt + replaceAmount,
        textOrTag.isTag ? [textOrTag.tag] : [],
      );
      value = TextEditingValue(
        text: text.replaceRange(range.start, range.end, textOrPlaceholder),
        selection: TextSelection.collapsed(
          offset: range.start + textOrPlaceholder.length,
        ),
      );
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final children = <InlineSpan>[];
    int index = 0;

    final segmentPattern = RegExp('$placeholder|[^$placeholder]+');
    final segments = segmentPattern.allMatches(text);

    for (final segment in segments) {
      if (segment.text == placeholder) {
        final isSelected = segment.range.within(selection);
        final tag = controller.tags.elementAtOrNull(index++);
        if (tag == null) continue;
        final widgetSpan = WidgetSpan(
          style: style,
          alignment: PlaceholderAlignment.middle,
          child: tagBuilder(tag, isSelected),
        );
        children.add(widgetSpan);
      } else {
        final textSpan = TextSpan(text: segment.text, style: style);
        children.add(textSpan);
      }
    }

    if (children.isEmpty) {
      final emptySpan = TextSpan(text: ' ', style: style);
      children.add(emptySpan);
    }

    return TextSpan(style: style, children: children);
  }
}
