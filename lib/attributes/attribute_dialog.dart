import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'attribute.dart';
import 'attribute_form.dart';
import 'attribute_form_state.dart';

class AttributeDialog extends StatefulWidget {
  const AttributeDialog({super.key, required this.initialAttribute});

  final Attribute? initialAttribute;

  @override
  State<AttributeDialog> createState() => _AttributeDialogState();
}

class _AttributeDialogState extends State<AttributeDialog> {
  final form = GlobalKey<AttributeFormState>();
  late final controller = AttributeFormController(widget.initialAttribute);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialAttribute != null ? "Edit Attribute" : "Create Attribute",
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: AttributeForm(
            key: form,
            controller: controller,
            onSubmit: (attribute) {
              context.pop(attribute);
            },
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
              onPressed: controller.hasChanges ? submitForm : null,
              child: Text(widget.initialAttribute != null ? "Save" : "Create"),
            );
          },
        ),
      ],
    );
  }

  void submitForm() {
    form.currentState!.submit();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Future<Attribute?> showAttributeDialog(
  BuildContext context, [
  Attribute? initialAttribute,
]) {
  return showDialog<Attribute>(
    context: context,
    builder: (context) {
      return AttributeDialog(initialAttribute: initialAttribute);
    },
  );
}
