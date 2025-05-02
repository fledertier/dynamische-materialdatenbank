import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../edit_mode_button.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'composition.dart';
import 'composition_dialog.dart';
import 'material_category.dart';
import 'proportions_widget.dart';

class CompositionCard extends ConsumerWidget {
  const CompositionCard(this.material, {super.key})
    : columns = 4,
      height = 40,
      axis = Axis.horizontal;

  const CompositionCard.small(this.material, {super.key})
    : columns = 2,
      height = null,
      axis = Axis.vertical;

  final Json material;
  final int columns;
  final double? height;
  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(Attributes.composition));

    final value = List<Json>.from(
      material[Attributes.composition] ??
          [
            {'category': MaterialCategory.minerals.name, 'share': 58},
            {'category': MaterialCategory.woods.name, 'share': 40},
            {'category': MaterialCategory.plastics.name, 'share': 2},
          ],
    );
    final composition = value.map(Composition.fromJson).toList();

    Future<void> updateComposition(MaterialCategory? category) async {
      final updatedComposition = await showDialog<List<Composition>>(
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
          Attributes.composition: updatedComposition.map(
            (composition) => composition.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: columns,
      label: AttributeLabel(label: attribute?.name),
      child: ProportionsWidget(
        height: height,
        axis: axis,
        edit: edit,
        proportions: composition,
        maxCount: MaterialCategory.values.length,
        update: (composition) {
          // todo: pass whole composition
          updateComposition(composition?.category);
        },
      ),
    );
  }
}
