import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impression.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubjectiveImpressionDialog extends StatefulWidget {
  const SubjectiveImpressionDialog({
    super.key,
    required this.subjectiveImpressions,
    this.initialSubjectiveImpression,
  });

  final List<SubjectiveImpression> subjectiveImpressions;
  final SubjectiveImpression? initialSubjectiveImpression;

  @override
  State<SubjectiveImpressionDialog> createState() =>
      _SubjectiveImpressionDialogState();
}

class _SubjectiveImpressionDialogState
    extends State<SubjectiveImpressionDialog> {
  final formKey = GlobalKey<FormState>();

  late final nameDe = ValueNotifier(
    widget.initialSubjectiveImpression?.name.valueDe,
  );
  late final nameEn = ValueNotifier(
    widget.initialSubjectiveImpression?.name.valueEn,
  );
  late final count = ValueNotifier(
    widget.initialSubjectiveImpression?.count.value,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialSubjectiveImpression == null
            ? 'Add subjective impression'
            : 'Edit subjective impression',
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
              initialValue: count.value?.toString(),
              decoration: InputDecoration(labelText: 'Count'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a count';
                }
                final intValue = int.tryParse(value);
                if (intValue == null || intValue < 1) {
                  return 'Please enter a valid count (1+)';
                }
                return null;
              },
              onChanged: (value) {
                count.value = int.tryParse(value);
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
          listenable: Listenable.merge([nameDe, nameEn, count]),
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
    return widget.initialSubjectiveImpression == null ||
        widget.initialSubjectiveImpression!.name.valueDe != nameDe.value ||
        widget.initialSubjectiveImpression!.name.valueEn != nameEn.value ||
        widget.initialSubjectiveImpression!.count.value != count.value;
  }

  void save() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.pop([
      ...widget.subjectiveImpressions.where(
        (subjectiveImpression) =>
            subjectiveImpression != widget.initialSubjectiveImpression,
      ),
      SubjectiveImpression(
        name: TranslatableText(valueDe: nameDe.value, valueEn: nameEn.value),
        count: UnitNumber(value: count.value!),
      ),
    ]);
  }
}
