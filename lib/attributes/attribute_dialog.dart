import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'attribute.dart';
import 'attribute_form.dart';
import 'attribute_form_controller.dart';

class AttributeDialog extends StatefulWidget {
  const AttributeDialog({
    super.key,
    required this.initialAttribute,
    required this.onSave,
  });

  final Attribute? initialAttribute;
  final void Function(Attribute attribute) onSave;

  @override
  State<AttributeDialog> createState() => _AttributeDialogState();
}

class _AttributeDialogState extends State<AttributeDialog> {
  final formKey = GlobalKey<AttributeFormState>();
  late final controller = AttributeFormController(widget.initialAttribute);

  AttributeFormState get form => formKey.currentState!;

  @override
  Widget build(BuildContext context) {
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
                  final attribute = await form.submit();
                  if (attribute != null) {
                    Navigator.of(context).pop(attribute);
                  }
                },
              ),
            Text(
              widget.initialAttribute != null
                  ? "Edit Attribute"
                  : "Create Attribute",
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: AttributeForm(
            key: formKey,
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
              child: Text(widget.initialAttribute != null ? "Save" : "Create"),
            );
          },
        ),
      ],
    );
  }

  submit() async {
    final attribute = await form.submit();
    if (attribute != null) {
      widget.onSave(attribute);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Future<Attribute?> showAttributeDialog({
  required BuildContext context,
  Attribute? initialAttribute,
  required void Function(Attribute attribute) onSave,
}) {
  return showDialog<Attribute>(
    context: context,
    builder: (context) {
      return Navigator(
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            PageRouteBuilder<Attribute>(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              pageBuilder: (context, animation, secondaryAnimation) {
                return AttributeDialog(
                  initialAttribute: initialAttribute,
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

Future<Attribute?> showNestedAttributeDialog({
  required BuildContext context,
  Attribute? initialAttribute,
  required void Function(Attribute attribute) onSave,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AttributeDialog(
          initialAttribute: initialAttribute,
          onSave: onSave,
        );
      },
    ),
  );
}
