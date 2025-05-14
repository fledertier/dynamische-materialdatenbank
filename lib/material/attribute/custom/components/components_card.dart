import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';
import '../../../../types.dart';
import '../../../edit_mode_button.dart';
import '../../../material_provider.dart';
import '../../../material_service.dart';
import '../../attribute_card.dart';
import '../../attribute_label.dart';
import '../../cards.dart';
import '../composition/proportions_widget.dart';
import 'component.dart';
import 'components_dialog.dart';
import 'components_list.dart';

class ComponentsCard extends ConsumerWidget {
  const ComponentsCard({
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
        'id': '1234',
        'nameDe': 'Portlandzement',
        'nameEn': 'Portland cement',
        'share': 44,
      },
      {
        'id': '2345',
        'nameDe': 'Schwedische Fichte',
        'nameEn': 'Wood Swedish fir',
        'share': 31,
      },
      {'id': '3456', 'nameDe': 'Wasser', 'nameEn': 'Water', 'share': 12},
      {
        'id': '4567',
        'nameDe': 'Kalksteinmehl',
        'nameEn': 'Limestone powder',
        'share': 9,
      },
      {
        'id': '5678',
        'nameDe': 'Farbe, wasserbasiert',
        'nameEn': 'Paint, water based',
        'share': 2,
      },
    ];

    final value =
        ref.watch(
          materialAttributeValueProvider(
            AttributeArgument(
              materialId: materialId,
              attributeId: Attributes.components,
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
        ref.read(materialServiceProvider).updateMaterialById(materialId, {
          Attributes.components: updatedComponents.map(
            (component) => component.toJson(),
          ),
        });
      }
    }

    return AttributeCard(
      columns: columns,
      label: AttributeLabel(attribute: Attributes.components),
      childPadding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ProportionsWidget(
              height: 40,
              axis: axis,
              edit: edit,
              proportions: components,
              update: updateComponents,
            ),
          ),
          if (axis == Axis.horizontal)
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
