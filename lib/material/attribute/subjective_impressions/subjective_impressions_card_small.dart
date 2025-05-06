import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../edit_mode_button.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'subjective_impression.dart';

class SubjectiveImpressionsCardSmall extends ConsumerWidget {
  const SubjectiveImpressionsCardSmall(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(
      attributeProvider(Attributes.subjectiveImpressions),
    );

    final value = List<Json>.from(
      material[Attributes.subjectiveImpressions] ??
          [
            {'name': 'Happiness', 'count': 3},
            {'name': 'Stress', 'count': 2},
            {'name': 'Calmness', 'count': 4},
            {'name': 'Guilt', 'count': 1},
            {'name': 'Sadness', 'count': 3},
            {'name': 'Anger', 'count': 2},
            {'name': 'Gratitude', 'count': 4},
            {'name': 'Love', 'count': 3},
            {'name': 'Relief', 'count': 1},
            {'name': 'Loneliness', 'count': 2},
            {'name': 'Fear', 'count': 1},
          ],
    );
    final impressions =
        value
            .map(SubjectiveImpression.fromJson)
            .sortedBy((impression) => impression.count)
            .reversed;

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(label: attribute?.name),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final impression in impressions)
            SubjectiveImpressionChip(
              impression: impression,
              edit: edit,
              onPressed: () {},
            ),
          if (edit)
            SizedBox(
              height: 36,
              child: IconButton.outlined(
                icon: Icon(Icons.add, size: 18),
                onPressed: () {},
              ),
            ),
        ],
      ),
    );
  }
}

class SubjectiveImpressionChip extends StatelessWidget {
  const SubjectiveImpressionChip({
    super.key,
    required this.impression,
    this.edit = false,
    this.onPressed,
  });

  final SubjectiveImpression impression;
  final bool edit;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !edit,
      child: ActionChip(
        label: Text(impression.name),
        shape: StadiumBorder(),
        side: BorderSide.none,
        backgroundColor: colorOf(impression),
        onPressed: onPressed,
      ),
    );
  }
}
