import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../../utils.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'subjective_impression.dart';
import 'subjective_impression_balls.dart';

class SubjectiveImpressionsCard extends ConsumerWidget {
  const SubjectiveImpressionsCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: SubjectiveImpressionBalls(
        width: widthByColumns(2),
        height: 260,
        impressions: impressions,
      ),
    );
  }
}
