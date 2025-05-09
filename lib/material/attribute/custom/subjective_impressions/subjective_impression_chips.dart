import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'subjective_impression.dart';

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

class SubjectiveImpressionChip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return IgnorePointer(
      ignoring: !edit,
      child: ActionChip(
        label: Text(
          impression.name,
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
