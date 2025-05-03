import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'component.dart';

class ComponentsDialog extends StatefulWidget {
  const ComponentsDialog({
    super.key,
    required this.components,
    this.initialComponent,
  });

  final List<Component> components;
  final Component? initialComponent;

  @override
  State<ComponentsDialog> createState() => _ComponentsDialogState();
}

class _ComponentsDialogState extends State<ComponentsDialog> {
  final formKey = GlobalKey<FormState>();

  late final nameDe = ValueNotifier(widget.initialComponent?.nameDe);
  late final nameEn = ValueNotifier(widget.initialComponent?.nameEn);
  late final share = ValueNotifier(widget.initialComponent?.share);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialComponent == null ? 'Add component' : 'Edit component',
      ),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            TextFormField(
              initialValue: nameDe.value,
              decoration: InputDecoration(labelText: 'Name (De)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onChanged: (value) {
                nameDe.value = value;
              },
            ),
            ListenableBuilder(
              listenable: nameDe,
              builder: (context, child) {
                return TextFormField(
                  initialValue: nameEn.value,
                  decoration: InputDecoration(
                    labelText: 'Name (En)',
                    hintText: nameDe.value,
                  ),
                  onChanged: (value) {
                    nameEn.value = value.isNotEmpty ? value : null;
                  },
                );
              },
            ),
            TextFormField(
              initialValue: share.value?.toString(),
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
              onChanged: (value) {
                share.value = num.tryParse(value);
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
        ListenableBuilder(
          listenable: Listenable.merge([nameDe, nameEn, share]),
          builder: (context, child) {
            return TextButton(
              onPressed: hasChanges ? save : null,
              child: Text('Save'),
            );
          },
        ),
      ],
    );
  }

  bool get hasChanges {
    return widget.initialComponent == null ||
        widget.initialComponent!.nameDe != nameDe.value ||
        widget.initialComponent!.nameEn != nameEn.value ||
        widget.initialComponent!.share != share.value;
  }

  void save() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.pop([
      ...widget.components.where(
        (component) => component != widget.initialComponent,
      ),
      Component(
        id: widget.initialComponent?.id ?? generateId(),
        nameDe: nameDe.value!,
        nameEn: nameEn.value,
        share: share.value!,
        color: ColorScheme.of(context).primaryFixedDim,
      ),
    ]);
  }
}
