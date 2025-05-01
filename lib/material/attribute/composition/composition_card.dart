import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../edit_mode_button.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'composition_dialog.dart';
import 'material_category.dart';
import 'proportion_widget.dart';

class CompositionCard extends ConsumerWidget {
  const CompositionCard(this.material, {super.key})
    : columns = 4,
      axis = Axis.horizontal;

  const CompositionCard.small(this.material, {super.key})
    : columns = 2,
      axis = Axis.vertical;

  final Json material;
  final int columns;
  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(Attributes.composition));

    final composition = Proportion.from(
      material[Attributes.composition] ??
          {
            MaterialCategory.minerals.name: 58,
            MaterialCategory.woods.name: 40,
            MaterialCategory.plastics.name: 2,
          },
    );
    final sortedComposition =
        composition
            .mapKeys(MaterialCategory.values.byName)
            .entries
            .sortedBy((entry) => entry.value)
            .reversed;

    Future<void> updateComposition(MaterialCategory? category) async {
      final updatedComposition = await showDialog<Proportion>(
        context: context,
        builder: (context) {
          return CompositionDialog(
            composition: composition,
            initialCategory: category,
          );
        },
      );
      if (updatedComposition != null) {
        ref.read(materialServiceProvider).updateMaterial({
          Attributes.id: material[Attributes.id],
          Attributes.composition: updatedComposition,
        });
      }
    }

    return AttributeCard(
      columns: columns,
      label: AttributeLabel(label: attribute?.name),
      child: SizedBox(
        height: switch (axis) {
          Axis.horizontal => 40,
          Axis.vertical => null,
        },
        child: Flex(
          direction: axis,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            for (final entry in sortedComposition)
              ProportionWidget(
                label: entry.key.name,
                color: entry.key.color,
                share: entry.value,
                maxShare: sortedComposition.first.value,
                onPressed: edit ? () => updateComposition(entry.key) : null,
                axis: axis,
              ),
            if (edit && composition.length < MaterialCategory.values.length)
              IconButton.outlined(
                icon: Icon(Icons.add),
                onPressed: () => updateComposition(null),
              ),
          ],
        ),
      ),
    );
  }
}
