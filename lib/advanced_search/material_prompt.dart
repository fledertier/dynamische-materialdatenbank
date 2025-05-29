import 'dart:ui_web';

import 'package:async/async.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../query/condition_group.dart';
import '../query/query_service.dart';

class MaterialPrompt extends ConsumerStatefulWidget {
  const MaterialPrompt({super.key, this.controller, this.onQuery});

  final TextEditingController? controller;
  final void Function(CancelableOperation<ConditionGroup?> query)? onQuery;

  @override
  ConsumerState<MaterialPrompt> createState() => _MaterialPromptState();
}

class _MaterialPromptState extends ConsumerState<MaterialPrompt> {
  late final controller = widget.controller ?? TextEditingController();
  CancelableOperation<ConditionGroup?>? _operation;
  bool isLoading = false;

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
          hintText: 'Oder beschreibe das Material...',
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
          isCollapsed: true,
          suffix:
              isLoading
                  ? IconButton.filled(
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(Icons.stop_rounded),
                    onPressed: () => _operation?.cancel(),
                  )
                  : IconButton.filled(
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
    if (isLoading) {
      _operation?.cancel();
    }

    final attributes = await ref.read(attributesProvider.future);
    final queryService = ref.read(queryServiceProvider);

    final futureQuery = queryService.generateQuery(
      attributes: attributes.values.toList(),
      types: attributes.values.map((attribute) => attribute.type).toList(),
      prompt: text.trim(),
    );

    final operation = CancelableOperation.fromFuture(futureQuery);
    widget.onQuery?.call(operation);

    operation.then(
      (value) => setState(() {
        isLoading = false;
      }),
      onCancel:
          () => setState(() {
            isLoading = false;
          }),
      onError:
          (error, stackTrace) => setState(() {
            isLoading = false;
          }),
    );

    setState(() {
      isLoading = true;
      _operation = operation;
    });
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
