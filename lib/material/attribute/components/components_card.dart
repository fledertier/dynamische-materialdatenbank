import 'package:collection/collection.dart';
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
import '../composition/proportion_widget.dart';
import 'component.dart';

class ComponentsCard extends ConsumerWidget {
  const ComponentsCard(this.material, {super.key})
    : columns = 4,
      height = 40,
      axis = Axis.horizontal;

  const ComponentsCard.small(this.material, {super.key})
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
    final attribute = ref.watch(attributeProvider(Attributes.components));

    final value = List<Json>.from(
      material[Attributes.components] ??
          [
            {'id': '1234', 'name': 'Portland cement', 'share': 44},
            {'id': '2345', 'name': 'Wood Swedish fir', 'share': 31},
            {'id': '3456', 'name': 'Water', 'share': 12},
            {'id': '4567', 'name': 'Limestone powder', 'share': 9},
            {'id': '5678', 'name': 'Paint, water based', 'share': 2},
          ],
    );
    final components = value.map(Component.fromJson).toList();
    final sortedComponents =
        components.sortedBy((component) => component.share).reversed;

    Future<void> updateComponents(String? id) async {
      final updatedComponents = await showDialog<List<Component>>(
        context: context,
        builder: (context) {
          return ComponentsDialog(components: components, id: id);
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
      child: SizedBox(
        height: height,
        child: Flex(
          direction: axis,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            for (final entry in sortedComponents)
              ProportionWidget(
                proportion: Proportion(
                  label: entry.name,
                  color: ColorScheme.of(context).primaryContainer,
                  share: entry.share,
                ),
                maxShare: sortedComponents.first.share,
                onPressed: edit ? () => updateComponents(entry.id) : null,
                axis: axis,
              ),
            if (edit)
              IconButton.outlined(
                icon: Icon(Icons.add),
                onPressed: () => updateComponents(null),
              ),
          ],
        ),
      ),
    );
  }
}
