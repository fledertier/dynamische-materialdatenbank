import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'object_attribute_form.dart';

class ObjectAttributeDialog extends ConsumerStatefulWidget {
  const ObjectAttributeDialog({
    super.key,
    required this.attributeId,
    required this.initialObject,
    required this.onSave,
  });

  final String attributeId;
  final Json? initialObject;
  final void Function(Json? object) onSave;

  @override
  ConsumerState<ObjectAttributeDialog> createState() =>
      _ObjectAttributeDialogState();
}

class _ObjectAttributeDialogState extends ConsumerState<ObjectAttributeDialog> {
  final formKey = GlobalKey<ObjectAttributeFormState>();

  late final controller = ValueNotifier<Json?>(widget.initialObject);

  ObjectAttributeFormState get form => formKey.currentState!;

  @override
  Widget build(BuildContext context) {
    final attribute = ref.watch(attributeProvider(widget.attributeId)).value;
    final name = attribute?.name ?? "Object";
    final canPop = Navigator.of(context).canPop();

    return AlertDialog(
      titlePadding: EdgeInsets.only(left: canPop ? 12 : 24, top: 24, right: 24),
      title: SizedBox(
        height: 40,
        child: Row(
          spacing: 8,
          children: [
            if (canPop)
              BackButton(
                color: ColorScheme.of(context).onSurface,
                onPressed: () async {
                  await save();
                  Navigator.of(context).pop();
                },
              ),
            Text(widget.initialObject != null ? "Edit $name" : "Create $name"),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: ObjectAttributeForm(
            key: formKey,
            attributeId: widget.attributeId,
            controller: controller,
            onSave: widget.onSave,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return TextButton(
              onPressed: () async {
                await save();
                context.pop();
              },
              child: Text(widget.initialObject != null ? "Save" : "Create"),
            );
          },
        ),
      ],
    );
  }

  Future<void> save() async {
    if (!form.validate()) {
      debugPrint("Form for ${widget.attributeId} is not valid");
      return;
    }
    final object = await form.submit();
    widget.onSave(object);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Future<Json?> showObjectAttributeDialog({
  required BuildContext context,
  required String attributeId,
  Json? initialObject,
  bool isRoot = false,
  required void Function(Json? value) onSave,
}) {
  final pageRoute = PageRouteBuilder<Json>(
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    barrierDismissible: !isRoot,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ObjectAttributeDialog(
        attributeId: attributeId,
        initialObject: initialObject,
        onSave: onSave,
      );
    },
  );
  if (isRoot) {
    return showDialog<Json>(
      context: context,
      builder: (context) {
        return Navigator(
          onGenerateInitialRoutes: (navigator, initialRoute) => [pageRoute],
        );
      },
    );
  }
  return Navigator.of(context).push(pageRoute);
}
