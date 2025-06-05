import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impression.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impression_balls.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impression_chips.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/subjective_impressions/subjective_impression_dialog.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectiveImpressionsCard extends ConsumerWidget {
  const SubjectiveImpressionsCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);

    final exampleValue = [
      {'nameDe': 'rau', 'nameEn': 'rough', 'count': 4},
      {'nameDe': 'glatt', 'nameEn': 'smooth', 'count': 1},
      {'nameDe': 'kalt', 'nameEn': 'cold', 'count': 2},
      {'nameDe': 'warm', 'nameEn': 'warm', 'count': 3},
      {'nameDe': 'weich', 'nameEn': 'soft', 'count': 1},
      {'nameDe': 'hart', 'nameEn': 'hard', 'count': 2},
    ];

    final value =
        ref.watch(
          jsonValueProvider(
            AttributeArgument(
              materialId: materialId,
              attributeId: Attributes.subjectiveImpressions,
            ),
          ),
        ) ??
        exampleValue;

    final impressions =
        List<Json>.from(value).map(SubjectiveImpression.fromJson).toList();

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
        ref.read(materialProvider(materialId).notifier).updateMaterial({
          Attributes.subjectiveImpressions: updatedSubjectiveImpressions.map(
            (subjectiveImpression) => subjectiveImpression.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(attributeId: Attributes.subjectiveImpressions),
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
