import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
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
      {
        '01973a53-3ad5-7a63-a6fd-d238fa571298': {
          'valueDe': 'rau',
          'valueEn': 'rough',
        },
        '01973a53-c53f-7ea3-a53f-3d21fffb2ca3': {'value': 4},
      },
      {
        '01973a53-3ad5-7a63-a6fd-d238fa571298': {
          'valueDe': 'glatt',
          'valueEn': 'smooth',
        },
        '01973a53-c53f-7ea3-a53f-3d21fffb2ca3': {'value': 1},
      },
      {
        '01973a53-3ad5-7a63-a6fd-d238fa571298': {
          'valueDe': 'kalt',
          'valueEn': 'cold',
        },
        '01973a53-c53f-7ea3-a53f-3d21fffb2ca3': {'value': 2},
      },
      {
        '01973a53-3ad5-7a63-a6fd-d238fa571298': {
          'valueDe': 'warm',
          'valueEn': 'warm',
        },
        '01973a53-c53f-7ea3-a53f-3d21fffb2ca3': {'value': 3},
      },
      {
        '01973a53-3ad5-7a63-a6fd-d238fa571298': {
          'valueDe': 'weich',
          'valueEn': 'soft',
        },
        '01973a53-c53f-7ea3-a53f-3d21fffb2ca3': {'value': 1},
      },
      {
        '01973a53-3ad5-7a63-a6fd-d238fa571298': {
          'valueDe': 'hart',
          'valueEn': 'hard',
        },
        '01973a53-c53f-7ea3-a53f-3d21fffb2ca3': {'value': 2},
      },
    ];

    final value =
        ref.watch(
          jsonValueProvider(
            AttributeArgument(
              materialId: materialId,
              attributePath: AttributePath(Attributes.subjectiveImpressions),
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
