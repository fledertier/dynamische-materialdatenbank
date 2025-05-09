import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../edit_mode_button.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import '../cards.dart';
import 'composition.dart';
import 'composition_dialog.dart';
import 'material_category.dart';
import 'proportions_widget.dart';

class CompositionCard extends ConsumerWidget {
  const CompositionCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
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
        ref.read(materialServiceProvider).updateMaterial(material, {
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
        height: 40,
        axis: axis,
        edit: edit,
        maxCount: MaterialCategory.values.length,
        proportions: composition,
        update: updateComposition,
      ),
    );
  }
}
