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

    final components = Proportions.from(
      material[Attributes.components] ??
          {
            'Portland cement': 44,
            'Wood Swedish fir': 31,
            'Water': 12,
            'Limestone powder': 9,
            'Paint, water based': 2,
          },
    );
    final sortedComponents =
        components.entries.sortedBy((entry) => entry.value).reversed;

    Future<void> updateComponents(String? name) async {
      final updatedComponents = await showDialog<Proportions>(
        context: context,
        builder: (context) {
          return ComponentsDialog(components: components, initialName: name);
        },
      );
      if (updatedComponents != null) {
        ref.read(materialServiceProvider).updateMaterial({
          Attributes.id: material[Attributes.id],
          Attributes.components: updatedComponents,
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
                label: entry.key,
                color: ColorScheme.of(context).primaryContainer,
                share: entry.value,
                maxShare: sortedComponents.first.value,
                onPressed: edit ? () => updateComponents(entry.key) : null,
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
