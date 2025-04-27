import 'dart:ui_web';

import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../attributes/attribute_type.dart';
import '../query/condition_group.dart';
import '../query/query_service.dart';

class MaterialPrompt extends ConsumerStatefulWidget {
  const MaterialPrompt({super.key, this.onQuery});

  final void Function(ConditionGroup query)? onQuery;

  @override
  ConsumerState<MaterialPrompt> createState() => _MaterialPromptState();
}

class _MaterialPromptState extends ConsumerState<MaterialPrompt> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: detectNewLine,
      child: TextField(
        controller: controller,
        minLines: 3,
        maxLines: 8,
        textInputAction:
            BrowserDetection.instance.isMobile
                ? TextInputAction.newline
                : TextInputAction.done,
        keyboardType: TextInputType.multiline,
        onSubmitted: submit,
        decoration: InputDecoration(
          hintText: 'Order beschreibe das Material...',
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
          isCollapsed: true,
          suffix: IconButton.filled(
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Icon(Icons.arrow_upward),
            onPressed: () => submit(controller.text),
          ),
        ),
      ),
    );
  }

  void submit(String text) async {
    final attributes = await ref.read(attributesStreamProvider.future);
    final queryService = ref.read(queryServiceProvider);

    final query = await queryService.generateQuery(
      attributes: attributes.values.toList(),
      types: AttributeType.values,
      prompt: text.trim(),
    );

    if (query != null) {
      widget.onQuery?.call(query);
    }
  }

  KeyEventResult detectNewLine(FocusNode node, KeyEvent event) {
    final isKeyDown = event is KeyDownEvent || event is KeyRepeatEvent;
    late final isShiftAndEnter =
        HardwareKeyboard.instance.isShiftPressed &&
        event.physicalKey == PhysicalKeyboardKey.enter;

    if (isKeyDown && isShiftAndEnter) {
      insertNewLine();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void insertNewLine() {
    final value = controller.value;
    controller.value = value.replaced(value.selection, "\n");
  }
}
