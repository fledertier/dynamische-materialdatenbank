import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';
import '../../../../types.dart';
import '../../../../utils.dart';
import '../../../edit_mode_button.dart';
import '../../../material_service.dart';
import '../../attribute_card.dart';
import '../../attribute_label.dart';
import '../../cards.dart';
import 'subjective_impression.dart';
import 'subjective_impression_balls.dart';
import 'subjective_impression_chips.dart';
import 'subjective_impression_dialog.dart';

class SubjectiveImpressionsCard extends ConsumerWidget {
  const SubjectiveImpressionsCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);

    final value = List<Json>.from(
      material[Attributes.subjectiveImpressions] ??
          [
            {'nameDe': 'rau', 'nameEn': 'rough', 'count': 4},
            {'nameDe': 'glatt', 'nameEn': 'smooth', 'count': 1},
            {'nameDe': 'kalt', 'nameEn': 'cold', 'count': 2},
            {'nameDe': 'warm', 'nameEn': 'warm', 'count': 3},
            {'nameDe': 'weich', 'nameEn': 'soft', 'count': 1},
            {'nameDe': 'hart', 'nameEn': 'hard', 'count': 2},
          ],
    );
    final impressions = value.map(SubjectiveImpression.fromJson).toList();

    Future<void> updateSubjectiveImpressions(
      SubjectiveImpression? initialSubjectiveImpression,
    ) async {
      final updatedSubjectiveImpressions =
          await showDialog<List<SubjectiveImpression>>(
            context: context,
            builder: (context) {
              return SubjectiveImpressionDialog(
                subjectiveImpressions: impressions,
                initialSubjectiveImpression: initialSubjectiveImpression,
              );
            },
          );
      if (updatedSubjectiveImpressions != null) {
        ref.read(materialServiceProvider).updateMaterial(material, {
          Attributes.subjectiveImpressions: updatedSubjectiveImpressions.map(
            (subjectiveImpression) => subjectiveImpression.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(attribute: Attributes.subjectiveImpressions),
      clip: Clip.antiAlias,
      childPadding:
          size == CardSize.small ? EdgeInsets.all(16) : EdgeInsets.zero,
      child: switch (size) {
        CardSize.large => SubjectiveImpressionBalls(
          key: ValueKey([edit, impressions]),
          width: widthByColumns(2),
          impressions: impressions,
          onUpdate: updateSubjectiveImpressions,
          edit: edit,
        ),
        CardSize.small => SubjectiveImpressionChips(
          impressions: impressions,
          onUpdate: updateSubjectiveImpressions,
          edit: edit,
        ),
      },
    );
  }
}
