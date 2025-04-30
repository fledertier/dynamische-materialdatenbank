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
import 'composition_element.dart';
import 'material_category.dart';

typedef Composition = Map<String, num>;

class CompositionCard extends ConsumerWidget {
  const CompositionCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.composition));
    final composition = Composition.from(
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

    final edit = ref.watch(editModeProvider);

    Future<void> updateComposition(MaterialCategory? category) async {
      final updatedComposition = await showDialog<Composition>(
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
      columns: 4,
      label: AttributeLabel(label: attribute?.name),
      child: SizedBox(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            for (final entry in sortedComposition)
              CompositionElement(
                category: entry.key,
                share: entry.value,
                onPressed: edit ? () => updateComposition(entry.key) : null,
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
