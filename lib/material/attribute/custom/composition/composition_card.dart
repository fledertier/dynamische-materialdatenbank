import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';
import '../../../../types.dart';
import '../../../edit_mode_button.dart';
import '../../../material_provider.dart';
import '../../attribute_card.dart';
import '../../attribute_label.dart';
import '../../cards.dart';
import 'composition.dart';
import 'composition_dialog.dart';
import 'material_category.dart';
import 'proportions_widget.dart';

class CompositionCard extends ConsumerWidget {
  const CompositionCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  int get columns {
    return switch (size) {
      CardSize.large => 4,
      CardSize.small => 2,
    };
  }

  Axis get axis {
    return switch (size) {
      CardSize.large => Axis.horizontal,
      CardSize.small => Axis.vertical,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);

    final exampleValue = [
      {'category': MaterialCategory.minerals.name, 'share': 58},
      {'category': MaterialCategory.woods.name, 'share': 40},
      {'category': MaterialCategory.plastics.name, 'share': 2},
    ];

    final value =
        ref.watch(
          materialAttributeValueProvider(
            AttributeArgument(
              materialId: materialId,
              attributeId: Attributes.composition,
            ),
          ),
        ) ??
        exampleValue;

    final composition =
        List<Json>.from(value).map(Composition.fromJson).toList();

    Future<void> updateComposition(Composition? initialComposition) async {
      final updatedComposition = await showDialog<List<Composition>>(
        context: context,
        builder: (context) {
          return CompositionDialog(
            composition: composition,
            initialComposition: initialComposition,
          );
        },
      );
      if (updatedComposition != null) {
        ref.read(materialProvider(materialId).notifier).updateMaterial({
          Attributes.composition: updatedComposition.map(
            (composition) => composition.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: columns,
      label: AttributeLabel(attribute: Attributes.composition),
      child: ProportionsWidget(
        height: 48,
        axis: axis,
        edit: edit,
        maxCount: MaterialCategory.values.length,
        proportions: composition,
        update: updateComposition,
      ),
    );
  }
}
