import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/composition.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/material_category.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/widgets/dropdown_menu_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompositionDialog extends StatefulWidget {
  const CompositionDialog({
    super.key,
    required this.composition,
    this.initialComposition,
  });

  final List<Composition> composition;
  final Composition? initialComposition;

  @override
  State<CompositionDialog> createState() => _CompositionDialogState();
}

class _CompositionDialogState extends State<CompositionDialog> {
  final formKey = GlobalKey<FormState>();

  late final category = ValueNotifier(widget.initialComposition?.category);
  late final share = ValueNotifier(widget.initialComposition?.share.value);

  Iterable<MaterialCategory> get availableCategories {
    if (widget.initialComposition == null) {
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
    return AlertDialog(
      title: Text(
        widget.initialComposition == null ? 'Add category' : 'Edit category',
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
              enabled: widget.initialComposition == null,
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
    return widget.initialComposition == null ||
        widget.initialComposition!.category != category.value ||
        widget.initialComposition!.share.value != share.value;
  }

  void save() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.pop([
      ...widget.composition.where(
        (composition) => composition != widget.initialComposition,
      ),
      Composition(
        category: category.value!,
        share: UnitNumber(value: share.value!),
      ),
    ]);
  }
}
