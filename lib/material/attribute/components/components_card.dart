import 'package:dynamische_materialdatenbank/material/attribute/components/components_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../../edit_mode_button.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import '../composition/proportions_widget.dart';
import 'component.dart';

class ComponentsCard extends ConsumerWidget {
  const ComponentsCard(this.material, {super.key})
    : columns = 4,
      axis = Axis.horizontal;

  const ComponentsCard.small(this.material, {super.key})
    : columns = 2,
      axis = Axis.vertical;

  final Json material;
  final int columns;
  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(Attributes.components));

    final value = List<Json>.from(
      material[Attributes.components] ??
          [
            {
              'id': '1234',
              'name': 'Portland cement',
              'share': 44,
              'color': 4288979605,
            },
            {
              'id': '2345',
              'name': 'Wood Swedish fir',
              'share': 31,
              'color': 4290027903,
            },
            {'id': '3456', 'name': 'Water', 'share': 12, 'color': 4287024366},
            {
              'id': '4567',
              'name': 'Limestone powder',
              'share': 9,
              'color': 4291938740,
            },
            {
              'id': '5678',
              'name': 'Paint, water based',
              'share': 2,
              'color': 4279735534,
            },
          ],
    );
    final components = value.map(Component.fromJson).toList();

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
        ref.read(materialServiceProvider).updateMaterial({
          Attributes.id: material[Attributes.id],
          Attributes.components: updatedComponents.map(
            (component) => component.toJson(),
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
        proportions: components,
        update: updateComponents,
      ),
    );
  }
}
