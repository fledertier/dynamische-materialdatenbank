import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../../utils.dart';
import '../../edit_mode_button.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'subjective_impression.dart';
import 'subjective_impression_balls.dart';
import 'subjective_impression_chips.dart';
import 'subjective_impression_dialog.dart';

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
        ref.read(materialServiceProvider).updateMaterial({
          Attributes.id: material[Attributes.id],
          Attributes.subjectiveImpressions: updatedSubjectiveImpressions.map(
            (subjectiveImpression) => subjectiveImpression.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(label: attribute?.name),
      clip: Clip.antiAlias,
      childPadding: small ? EdgeInsets.all(16) : EdgeInsets.zero,
      child: switch (small) {
        false => SubjectiveImpressionBalls(
          key: ValueKey([edit, impressions]),
          width: widthByColumns(2),
          impressions: impressions,
          onUpdate: updateSubjectiveImpressions,
          edit: edit,
        ),
        true => SubjectiveImpressionChips(
          impressions: impressions,
          onUpdate: updateSubjectiveImpressions,
          edit: edit,
        ),
      },
    );
  }
}
