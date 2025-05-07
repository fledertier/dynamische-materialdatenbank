import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../../utils.dart';
import '../../edit_mode_button.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'subjective_impression.dart';
import 'subjective_impression_balls.dart';
import 'subjective_impression_chips.dart';

class SubjectiveImpressionsCard extends ConsumerWidget {
  const SubjectiveImpressionsCard(this.material, {super.key}) : small = false;

  const SubjectiveImpressionsCard.small(this.material, {super.key})
    : small = true;

  final Json material;
  final bool small;

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
    final impressions = value.map(SubjectiveImpression.fromJson).toList();

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(label: attribute?.name),
      clip: Clip.antiAlias,
      childPadding: EdgeInsets.zero,
      child: switch (small) {
        false => SubjectiveImpressionBalls(
          key: ValueKey(edit),
          width: widthByColumns(2),
          height: 260,
          impressions: impressions,
          onUpdate: update,
          edit: edit,
        ),
        true => SubjectiveImpressionChips(
          impressions: impressions,
          onUpdate: update,
          edit: edit,
        ),
      },
    );
  }

  void update(SubjectiveImpression? impression) {}
}
