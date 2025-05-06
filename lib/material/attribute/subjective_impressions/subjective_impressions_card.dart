import 'package:flutter/material.dart';

import '../../../types.dart';
import '../../../utils.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'subjective_impression.dart';
import 'subjective_impression_balls.dart';

class SubjectiveImpressionsCard extends StatelessWidget {
  const SubjectiveImpressionsCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context) {
    final impressions = [
      SubjectiveImpression(name: 'Happiness', count: 3),
      SubjectiveImpression(name: 'Stress', count: 2),
      SubjectiveImpression(name: 'Calmness', count: 4),
      SubjectiveImpression(name: 'Guilt', count: 1),
      SubjectiveImpression(name: 'Sadness', count: 3),
      SubjectiveImpression(name: 'Anger', count: 2),
      SubjectiveImpression(name: 'Gratitude', count: 4),
      SubjectiveImpression(name: 'Love', count: 3),
      SubjectiveImpression(name: 'Relief', count: 1),
      SubjectiveImpression(name: 'Loneliness', count: 2),
      SubjectiveImpression(name: 'Fear', count: 1),
    ];
    return AttributeCard(
      columns: 2,
      label: AttributeLabel(label: 'Subjective impressions'),
      childPadding: EdgeInsets.zero,
      clip: Clip.antiAlias,
      child: SubjectiveImpressionBalls(
        width: widthByColumns(2),
        height: 260,
        impressions: impressions,
      ),
    );
  }
}
