import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/tags_controller.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/tags_editing_controller.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/text_or_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:super_clipboard/super_clipboard.dart';

abstract class Suggestion<T> {
  const Suggestion();
}

class SuggestValue<T> extends Suggestion<T> {
  const SuggestValue(this.value);

  final T value;
}

class SuggestCreation<T> extends Suggestion<T> {
  const SuggestCreation(this.text);

  final String text;
}

class CompleteTagIntent extends Intent {
  const CompleteTagIntent();
}

class SelectDeleteTagIntent extends Intent {
  const SelectDeleteTagIntent();
}

class UnfocusIntent extends Intent {
  const UnfocusIntent();
}

typedef SuggestValueBuilder<T> = Widget Function(BuildContext context, T value);
typedef SuggestCreationBuilder<T> =
    Widget Function(BuildContext context, String value);

typedef TagBuilder<T> = Widget Function(T value, bool isSelected);
typedef TextExtractor<T> = String Function(T value);

class TagsField<T> extends StatefulWidget {
  const TagsField({
    super.key,
    this.decoration = const InputDecoration(),
    this.controller,
    this.suggestionsController,
    required this.suggestions,
    required this.suggestValueBuilder,
    this.suggestCreationBuilder,
    required this.tagBuilder,
    this.onCreate,
    required this.textExtractor,
    this.hideSuggestionsOnSelect = false,
    this.onChanged,
    this.initialTags,
  });

  final InputDecoration? decoration;
  final TagsController<T>? controller;
  final SuggestionsController<Suggestion<T>>? suggestionsController;
  final List<T> suggestions;
  final SuggestValueBuilder<T> suggestValueBuilder;
  final SuggestCreationBuilder<T>? suggestCreationBuilder;
  final TagBuilder<T> tagBuilder;
  final FutureOr<T?> Function(String text)? onCreate;
  final TextExtractor<T> textExtractor;
  final bool hideSuggestionsOnSelect;
  final ValueChanged<List<T>>? onChanged;
  final List<T>? initialTags;

  @override
  State<TagsField<T>> createState() => _TagsFieldState<T>();
}

class _TagsFieldState<T> extends State<TagsField<T>> {
  late final SuggestionsController<Suggestion<T>> _suggestionsController;
  late final TagsController<T> _tagsController;
  late final TagsEditingController<T> _editingController;
  final _focusNode = FocusNode();
  final _compositingRange = ValueNotifier(TextRange.empty);
  final _clipboardEventThrottler = Throttler();

  @override
  void initState() {
    super.initState();

    _suggestionsController =
        widget.suggestionsController ?? SuggestionsController<Suggestion<T>>();

    _tagsController =
        widget.controller ?? TagsController(tags: widget.initialTags);
    _tagsController.addListener(() {
      widget.onChanged?.call(_tagsController.tags);
    });

    _editingController = TagsEditingController<T>(
      controller: _tagsController,
      tagBuilder: widget.tagBuilder,
      textExtractor: widget.textExtractor,
    );
    _editingController.addListener(() {
      _compositingRange.value = _editingController.composingRange();
    });

    _compositingRange.addListener(() {
      _suggestionsController.refresh();
    });

    ClipboardEvents.instance?.registerPasteEventListener(_onPasteEvent);
    ClipboardEvents.instance?.registerCopyEventListener(_onCopyEvent);
    ClipboardEvents.instance?.registerCutEventListener(_onCutEvent);
  }

  @override
  void dispose() {
    if (widget.suggestionsController == null) {
      _suggestionsController.dispose();
    }
    if (widget.controller == null) {
      _tagsController.dispose();
    }
    _editingController.dispose();
    _focusNode.dispose();

    ClipboardEvents.instance?.unregisterPasteEventListener(_onPasteEvent);
    ClipboardEvents.instance?.unregisterCopyEventListener(_onCopyEvent);
    ClipboardEvents.instance?.unregisterCutEventListener(_onCutEvent);

    _clipboardEventThrottler.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        SingleActivator(LogicalKeyboardKey.enter): const CompleteTagIntent(),
        SingleActivator(LogicalKeyboardKey.backspace):
            const SelectDeleteTagIntent(),
        SingleActivator(LogicalKeyboardKey.escape): const UnfocusIntent(),
      },
      child: Actions(
        actions: {
          CompleteTagIntent: CallbackAction<CompleteTagIntent>(
            onInvoke: (intent) {
              _completeTag();
              return null;
            },
          ),
          SelectDeleteTagIntent: CallbackAction<SelectDeleteTagIntent>(
            onInvoke: (intent) {
              _selectOrDelete();
              return null;
            },
          ),
          UnfocusIntent: CallbackAction<UnfocusIntent>(
            onInvoke: (intent) {
              _focusNode.unfocus();
              return null;
            },
          ),
        },
        child: TypeAheadField<Suggestion<T>>(
          suggestionsController: _suggestionsController,
          controller: _editingController,
          focusNode: _focusNode,
          itemBuilder: (context, suggestion) {
            switch (suggestion) {
              case final SuggestCreation<T> suggestion:
                return widget.suggestCreationBuilder!(context, suggestion.text);
              case final SuggestValue<T> suggestion:
                return widget.suggestValueBuilder(context, suggestion.value);
              default:
                throw UnsupportedError(
                  'Unsupported suggestion type ${suggestion.runtimeType}',
                );
            }
          },
          hideOnEmpty: true,
          hideOnSelect: widget.hideSuggestionsOnSelect,
          onSelected: (suggestion) async {
            if (suggestion is SuggestCreation<T>) {
              final value = await widget.onCreate?.call(suggestion.text);
              if (value != null) {
                _insertTag(value);
              }
            } else if (suggestion is SuggestValue<T>) {
              _insertTag(suggestion.value);
            }
          },
          suggestionsCallback: (_) {
            if (_tagsController.maxNumberOfTagsReached()) {
              return [];
            }
            final search = _searchText();
            return _findSuggestions(widget.suggestions, search);
          },
          listBuilder: (context, children) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 240),
              child: ListView(shrinkWrap: true, children: children),
            );
          },
          builder: (context, controller, focusNode) {
            return TextField(
              focusNode: focusNode,
              controller: controller,
              decoration: widget.decoration,
              strutStyle: StrutStyle(forceStrutHeight: false),
              maxLines: null,
              textInputAction: TextInputAction.done,
              onSubmitted: (text) {
                Actions.invoke(context, const CompleteTagIntent());
              },
            );
          },
        ),
      ),
    );
  }

  void _selectOrDelete() {
    _canSelectTag() ? _selectTag() : _delete();
  }

  bool _canSelectTag() {
    late final composingText = _editingController.composingText();
    return _editingController.selection.isCollapsed &&
        composingText.contains(TagsEditingController.placeholder);
  }

  void _selectTag() {
    final composingRange = _editingController.composingRange();
    _editingController.selection = composingRange.asSelection;
  }

  void _completeTag() {
    final suggestion = _suggestionsController.suggestions?.firstOrNull;
    if (suggestion != null) {
      _suggestionsController.select(suggestion);
    }
  }

  void _delete() {
    final selection = _editingController.selection;
    if (selection.isCollapsed) {
      final composingText = _editingController.composingText();
      if (composingText.isNotEmpty) {
        final shortened = composingText.substring(0, composingText.length - 1);
        _editingController.insertText(shortened, _compositingRange.value);
      }
    } else {
      _editingController.insertText('', selection);
    }
  }

  void _onPasteEvent(ClipboardReadEvent event) {
    if (!_focusNode.hasFocus) return;
    _clipboardEventThrottler.throttle(
      duration: Duration(milliseconds: 100),
      onThrottle: () => _onPasteEventThrottled(event),
    );
  }

  void _onPasteEventThrottled(ClipboardReadEvent event) async {
    final reader = await event.getClipboardReader();
    if (reader.canProvide(Formats.plainText)) {
      final text = await reader.readValue(Formats.plainText);
      if (text != null) _parseAndInsert(text);
    }
  }

  void _onCopyEvent(ClipboardWriteEvent event) {
    if (!_focusNode.hasFocus) return;
    _clipboardEventThrottler.throttle(
      duration: Duration(milliseconds: 100),
      onThrottle: () => _onCopyEventThrottled(event),
    );
  }

  void _onCopyEventThrottled(ClipboardWriteEvent event) {
    _copySelectionToClipboard(event);
  }

  void _onCutEvent(ClipboardWriteEvent event) {
    if (!_focusNode.hasFocus) return;
    _clipboardEventThrottler.throttle(
      duration: Duration(milliseconds: 100),
      onThrottle: () => _onCutEventThrottled(event),
    );
  }

  void _onCutEventThrottled(ClipboardWriteEvent event) {
    _copySelectionToClipboard(event);
    _delete();
  }

  void _copySelectionToClipboard(ClipboardWriteEvent event) {
    final text = _editingController.selectionAsPlainText();
    final item = DataWriterItem();
    item.add(Formats.plainText(text));
    event.write([item]);
  }

  String _searchText() {
    return _editingController
        .composingText()
        .replaceAll(',', '')
        .replaceAll(TagsEditingController.placeholder, '')
        .trim();
  }

  List<Suggestion<T>> _findSuggestions(List<T> tags, String search) {
    final exactTag = _findExact(tags, search);
    if (exactTag != null) {
      return [SuggestValue(exactTag)];
    }
    final matchingTags = _findMatching(tags, search);
    matchingTags.removeWhere(
      (tag) =>
          _findExact(_tagsController.tags, widget.textExtractor(tag)) != null,
    );
    return [
      if (search.isNotEmpty && widget.suggestCreationBuilder != null)
        SuggestCreation(search),
      for (final tag in matchingTags) SuggestValue(tag),
    ];
  }

  List<T> _findMatching(List<T> tags, String search) {
    final matchingTags = tags.where(
      (tag) => widget
          .textExtractor(tag)
          .toLowerCase()
          .contains(search.toLowerCase()),
    );
    return matchingTags.toList();
  }

  T? _findExact(List<T> tags, String search) {
    return tags.firstWhereOrNull(
      (tag) => widget.textExtractor(tag).toLowerCase() == search.toLowerCase(),
    );
  }

  void _insertTag(T tag) {
    final selection = _editingController.selection;
    final range = _editingController.composingRange();
    final text = _editingController.composingText();

    if (text == TagsEditingController.placeholder && selection.isCollapsed) {
      _editingController.insertTag(tag, selection);
    } else {
      _editingController.insertTag(tag, range);
    }
  }

  void _parseAndInsert(String text) {
    final textsAndTags = _parseText(text);
    for (final textOrTag in textsAndTags) {
      _editingController.insert(textOrTag, _editingController.selection);
    }
  }

  Iterable<TextOrTag<T>> _parseText(String text) {
    final segments = text.split(',').map((s) => s.trim());
    return segments.mapIndexed((index, segment) {
      final tag = _findExact(widget.suggestions, segment);
      if (tag != null) {
        return TextOrTag.tag(tag);
      } else {
        final text = index == (segments.length - 1) ? segment : '$segment, ';
        return TextOrTag.text(text);
      }
    });
  }
}
