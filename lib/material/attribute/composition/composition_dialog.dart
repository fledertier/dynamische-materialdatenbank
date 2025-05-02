import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'composition.dart';
import 'material_category.dart';

class CompositionDialog extends StatefulWidget {
  const CompositionDialog({
    super.key,
    required this.composition,
    this.initialCategory,
  });

  final List<Composition> composition;
  final MaterialCategory? initialCategory;

  @override
  State<CompositionDialog> createState() => _CompositionDialogState();
}

class _CompositionDialogState extends State<CompositionDialog> {
  final formKey = GlobalKey<FormState>();

  late MaterialCategory category;
  late num share;

  Iterable<MaterialCategory> get availableCategories {
    if (widget.initialCategory == null) {
      return MaterialCategory.values.whereNot(
        (category) => widget.composition.any(
          (composition) => composition.category == category,
        ),
      );
    } else {
      return MaterialCategory.values;
    }
  }

  @override
  Widget build(BuildContext context) {
    final composition = widget.composition.singleWhereOrNull(
      (composition) => composition.category == widget.initialCategory,
    );
    return AlertDialog(
      title: Text(
        widget.initialCategory == null ? 'Add category' : 'Edit category',
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
              enabled: widget.initialCategory == null,
              initialSelection: composition?.category,
              dropdownMenuEntries: [
                for (final category in availableCategories)
                  DropdownMenuEntry(
                    leadingIcon: CircleAvatar(
                      radius: 10,
                      backgroundColor: category.color,
                    ),
                    label: category.name,
                    value: category,
                  ),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
              onSaved: (value) {
                category = value!;
              },
            ),
            TextFormField(
              initialValue: composition?.share.toString(),
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
                ...widget.composition.where(
                  (composition) =>
                      composition.category != widget.initialCategory,
                ),
                Composition(category: category, share: share),
              ]);
            }
          },
        ),
      ],
    );
  }
}
