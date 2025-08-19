import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/composition.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/material_category.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompositionDialog extends StatefulWidget {
  const CompositionDialog({
    super.key,
    required this.composition,
    this.initialElement,
  });

  final List<CompositionElement> composition;
  final CompositionElement? initialElement;

  @override
  State<CompositionDialog> createState() => _CompositionDialogState();
}

class _CompositionDialogState extends State<CompositionDialog> {
  final formKey = GlobalKey<FormState>();

  late final category = ValueNotifier(widget.initialElement?.category);
  late final share = ValueNotifier(widget.initialElement?.share.value);

  Iterable<MaterialCategory> get availableCategories => {
    if (widget.initialElement?.category != null)
      widget.initialElement!.category,
    for (final category in MaterialCategory.values)
      if (widget.composition.none((element) => element.category == category))
        category,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialElement == null ? 'Add category' : 'Edit category',
      ),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            DropdownMenuFormField(
              label: Text('Category'),
              expandedInsets: EdgeInsets.zero,
              requestFocusOnTap: false,
              initialSelection: category.value,
              dropdownMenuEntries: [
                for (final category in availableCategories)
                  DropdownMenuEntry(
                    leadingIcon: CircleAvatar(
                      radius: 10,
                      backgroundColor: category.color,
                    ),
                    label: category.nameDe,
                    value: category,
                  ),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
              onSelected: (value) {
                category.value = value;
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
          listenable: Listenable.merge([category, share]),
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
    return widget.initialElement == null ||
        widget.initialElement!.category != category.value ||
        widget.initialElement!.share.value != share.value;
  }

  void save() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.pop([
      ...widget.composition.where(
        (element) => element != widget.initialElement,
      ),
      CompositionElement(
        category: category.value!,
        share: UnitNumber(value: share.value!),
      ),
    ]);
  }
}
