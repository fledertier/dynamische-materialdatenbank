import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../attributes/attribute_provider.dart';
import '../../../../types.dart';
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
  final formKey = GlobalKey<FormState>();

  late final controller = ValueNotifier<Json?>(widget.initialObject);

  FormState get form => formKey.currentState!;

  @override
  Widget build(BuildContext context) {
    final attribute = ref.watch(attributeProvider(widget.attributeId));
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
                  // todo
                  // final value = await form.submit();
                  final value = null;
                  if (value != null) {
                    Navigator.of(context).pop(value);
                  }
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
              onPressed: submit,
              child: Text(widget.initialObject != null ? "Save" : "Create"),
            );
          },
        ),
      ],
    );
  }

  submit() async {
    // todo
    // final attribute = await form.submit();
    // if (attribute != null) {
    //   widget.onSave(attribute);
    // }
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
  required void Function(Json? value) onSave,
}) {
  return showDialog<Json?>(
    context: context,
    builder: (context) {
      return Navigator(
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            PageRouteBuilder<Json?>(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, animation, secondaryAnimation) {
                return ObjectAttributeDialog(
                  attributeId: attributeId,
                  initialObject: initialObject,
                  onSave: onSave,
                );
              },
            ),
          ];
        },
      );
    },
  );
}

Future<Json?> showNestedObjectAttributeDialog({
  required BuildContext context,
  required String materialId,
  required String attributeId,
  Json? initialValue,
  required void Function(Json? value) onSave,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ObjectAttributeDialog(
          attributeId: attributeId,
          initialObject: initialValue,
          onSave: onSave,
        );
      },
    ),
  );
}
