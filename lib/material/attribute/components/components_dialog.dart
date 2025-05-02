import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'component.dart';

class ComponentsDialog extends StatefulWidget {
  const ComponentsDialog({super.key, required this.components, this.id});

  final List<Component> components;
  final String? id;

  @override
  State<ComponentsDialog> createState() => _ComponentsDialogState();
}

class _ComponentsDialogState extends State<ComponentsDialog> {
  final formKey = GlobalKey<FormState>();

  late String name;
  late num share;

  @override
  Widget build(BuildContext context) {
    final component = widget.components.singleWhereOrNull(
      (component) => component.id == widget.id,
    );
    return AlertDialog(
      title: Text(widget.id == null ? 'Add component' : 'Edit component'),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            TextFormField(
              initialValue: component?.name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                name = value!;
              },
            ),
            TextFormField(
              initialValue: component?.share.toString(),
              decoration: InputDecoration(labelText: 'Share', suffixText: '%'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a share';
                }
                final numValue = num.tryParse(value);
                if (numValue == null || numValue < 0 || numValue > 100) {
                  return 'Please enter a valid share (0-100)';
                }
                return null;
              },
              onSaved: (value) {
                share = num.parse(value!);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            context.pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              context.pop([
                ...widget.components.where(
                  (component) => component.id != widget.id,
                ),
                Component(
                  id: widget.id ?? generateId(),
                  name: name,
                  share: share,
                ),
              ]);
            }
          },
        ),
      ],
    );
  }
}
