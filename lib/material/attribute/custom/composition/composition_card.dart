import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/composition.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/composition_dialog.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/material_category.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/proportions_widget.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      {
        '01973a7f-996f-7d2c-808c-facf1b23abed': {
          'valueDe': MaterialCategory.minerals.name,
        },
        '01973a80-26ff-7bee-bbc8-c93911d3fa2c': {'value': 58},
      },
      {
        '01973a7f-996f-7d2c-808c-facf1b23abed': {
          'valueDe': MaterialCategory.woods.name,
        },
        '01973a80-26ff-7bee-bbc8-c93911d3fa2c': {'value': 40},
      },
      {
        '01973a7f-996f-7d2c-808c-facf1b23abed': {
          'valueDe': MaterialCategory.plastics.name,
        },
        '01973a80-26ff-7bee-bbc8-c93911d3fa2c': {'value': 2},
      },
    ];

    final value =
        ref.watch(
          jsonValueProvider(
            AttributeArgument(
              materialId: materialId,
              attributePath: AttributePath(Attributes.composition),
            ),
          ),
        ) ??
        exampleValue;

    final composition =
        List<Json>.from(value).map(CompositionElement.fromJson).toList();

    Future<void> updateComposition(CompositionElement? element) async {
      final updatedComposition = await showDialog<List<CompositionElement>>(
        context: context,
        builder: (context) {
          return CompositionDialog(
            composition: composition,
            initialElement: element,
          );
        },
      );
      if (updatedComposition != null) {
        ref.read(materialProvider(materialId).notifier).updateMaterial({
          Attributes.composition: updatedComposition.map(
            (element) => element.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: columns,
      label: AttributeLabel(attributeId: Attributes.composition),
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
