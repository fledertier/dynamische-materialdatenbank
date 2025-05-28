import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EnumField<T> extends StatefulWidget {
  const EnumField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
    required this.suggestions,
    this.suggestionBuilder,
    this.findSuggestions,
    required this.textExtractor,
    this.style,
    this.decoration,
    this.validator,
  });

  final T? initialValue;
  final void Function(T? value) onChanged;
  final bool required;
  final bool enabled;
  final List<T> suggestions;
  final Widget Function(BuildContext context, T suggestion)? suggestionBuilder;
  final List<T> Function(String search)? findSuggestions;
  final String Function(T value) textExtractor;
  final TextStyle? style;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;

  @override
  State<EnumField<T>> createState() => _EnumFieldState<T>();
}

class _EnumFieldState<T> extends State<EnumField<T>> {
  final controller = TextEditingController();
  final suggestionsController = SuggestionsController<T>();
  final focusNode = FocusNode();
  late final ValueNotifier<T?> notifier;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      controller.text = widget.textExtractor(widget.initialValue!);
    }
    notifier = ValueNotifier<T?>(widget.initialValue);
    notifier.addListener(onChanged);
  }

  @override
  void dispose() {
    notifier.removeListener(onChanged);
    notifier.dispose();
    controller.dispose();
    suggestionsController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onChanged() {
    widget.onChanged(notifier.value);
  }

  Widget defaultSuggestionBuilder(BuildContext context, T suggestion) {
    return ListTile(title: Text(widget.textExtractor(suggestion)));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (value) {
        if (value is KeyDownEvent &&
            value.logicalKey == LogicalKeyboardKey.enter) {
          final suggestion = suggestionsController.suggestions?.firstOrNull;
          if (suggestion != null) {
            suggestionsController.select(suggestion);
          }
          focusNode.nextFocus();
        }
      },
      child: TypeAheadField<T>(
        controller: controller,
        suggestionsController: suggestionsController,
        itemBuilder: widget.suggestionBuilder ?? defaultSuggestionBuilder,
        hideOnEmpty: true,
        hideOnSelect: true,
        onSelected: (suggestion) async {
          final text = widget.textExtractor(suggestion);
          controller.value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
          notifier.value = suggestion;
        },
        suggestionsCallback: widget.findSuggestions ?? defaultFindSuggestions,
        listBuilder: (context, children) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 240),
            child: ListView(
              shrinkWrap: children.length < 10,
              children: children,
            ),
          );
        },
        builder: (context, controller, focusNode) {
          return TextFormField(
            focusNode: focusNode,
            controller: controller,
            style: widget.style,
            decoration: widget.decoration,
            strutStyle: StrutStyle(),
            textInputAction: TextInputAction.done,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUnfocus,
            onChanged: (value) {
              notifier.value = _findExact(widget.suggestions, value);
            },
          );
        },
      ),
    );
  }

  List<T> defaultFindSuggestions(String search) {
    final exactTag = _findExact(widget.suggestions, search);
    if (exactTag != null) {
      return [];
    }
    final matchingTags = _findMatching(widget.suggestions, search.trim());
    return [for (final tag in matchingTags) tag];
  }

  List<T> _findMatching(List<T> values, String search) {
    final matchingTags = values.where(
      (tag) => widget
          .textExtractor(tag)
          .toLowerCase()
          .contains(search.toLowerCase()),
    );
    return matchingTags.toList();
  }

  T? _findExact(List<T> values, String search) {
    return values.firstWhereOrNull(
      (tag) => widget.textExtractor(tag).toLowerCase() == search.toLowerCase(),
    );
  }
}
