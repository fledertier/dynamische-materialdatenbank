import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/components/component.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/components/components_dialog.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/components/components_list.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/proportions_widget.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentsCard extends ConsumerWidget {
  const ComponentsCard({
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
        'id': '1234',
        '01973a81-5717-732f-99c0-97481e1954c5': {
          'valueDe': 'Portlandzement',
          'valueEn': 'Portland cement',
        },
        '01973a81-b8b3-7214-b729-877d3d6cb394': {'value': 44},
      },
      {
        'id': '2345',
        '01973a81-5717-732f-99c0-97481e1954c5': {
          'valueDe': 'Schwedische Fichte',
          'valueEn': 'Wood Swedish fir',
        },
        '01973a81-b8b3-7214-b729-877d3d6cb394': {'value': 31},
      },
      {
        'id': '3456',
        '01973a81-5717-732f-99c0-97481e1954c5': {
          'valueDe': 'Wasser',
          'valueEn': 'Water',
        },
        '01973a81-b8b3-7214-b729-877d3d6cb394': {'value': 12},
      },
      {
        'id': '4567',
        '01973a81-5717-732f-99c0-97481e1954c5': {
          'valueDe': 'Kalksteinmehl',
          'valueEn': 'Limestone powder',
        },
        '01973a81-b8b3-7214-b729-877d3d6cb394': {'value': 9},
      },
      {
        'id': '5678',
        '01973a81-5717-732f-99c0-97481e1954c5': {
          'valueDe': 'Farbe, wasserbasiert',
          'valueEn': 'Paint, water based',
        },
        '01973a81-b8b3-7214-b729-877d3d6cb394': {'value': 2},
      },
    ];

    final value =
        ref.watch(
          jsonValueProvider(
            AttributeArgument(
              materialId: materialId,
              attributePath: AttributePath(Attributes.components),
            ),
          ),
        ) ??
        exampleValue;

    final components = List<Json>.from(value).map(Component.fromJson).toList();

    Future<void> updateComponents(Component? initialComponent) async {
      final updatedComponents = await showDialog<List<Component>>(
        context: context,
        builder: (context) {
          return ComponentsDialog(
            components: components,
            initialComponent: initialComponent,
          );
        },
      );
      if (updatedComponents != null) {
        ref.read(materialProvider(materialId).notifier).updateMaterial({
          Attributes.components: updatedComponents.map(
            (component) => component.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: switch (size) {
        CardSize.large => 4,
        CardSize.small => 2,
      },
      label: AttributeLabel(attributeId: Attributes.components),
      childPadding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ProportionsWidget(
              height: 40,
              axis: switch (size) {
                CardSize.large => Axis.horizontal,
                CardSize.small => Axis.vertical,
              },
              edit: edit,
              proportions: components,
              update: updateComponents,
            ),
          ),
          if (size == CardSize.large)
            ComponentsList(
              edit: edit,
              components: components,
              update: updateComponents,
            ),
        ],
      ),
    );
  }
}
