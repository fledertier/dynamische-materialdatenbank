import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/localization/language_button.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impression.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectiveImpressionChips extends StatelessWidget {
  const SubjectiveImpressionChips({
    super.key,
    required this.impressions,
    required this.onUpdate,
    required this.edit,
  });

  final List<SubjectiveImpression> impressions;
  final void Function(SubjectiveImpression?) onUpdate;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    final sortedImpressions =
        impressions.sortedBy((impression) => impression.count).reversed;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final impression in sortedImpressions)
          SubjectiveImpressionChip(
            impression: impression,
            onPressed: () => onUpdate(impression),
            edit: edit,
          ),
        if (edit)
          SizedBox(
            height: 36,
            child: IconButton.outlined(
              icon: Icon(Icons.add, size: 18),
              onPressed: () => onUpdate(null),
            ),
          ),
      ],
    );
  }
}

class SubjectiveImpressionChip extends ConsumerWidget {
  const SubjectiveImpressionChip({
    super.key,
    required this.impression,
    required this.onPressed,
    required this.edit,
  });

  final SubjectiveImpression impression;
  final VoidCallback onPressed;
  final bool edit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final language = ref.watch(languageProvider);

    return IgnorePointer(
      ignoring: !edit,
      child: ActionChip(
        label: Text(
          impression.name.resolve(language) ?? impression.name.value,
          style: textTheme.bodyMedium!.copyWith(color: Colors.black),
        ),
        shape: StadiumBorder(),
        side: BorderSide.none,
        backgroundColor: colorOf(impression),
        onPressed: onPressed,
      ),
    );
  }
}
