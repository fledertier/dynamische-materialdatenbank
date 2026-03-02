import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_label.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/components/component.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/components/components_dialog.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/components/components_list.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/composition/proportions_widget.dart';
import 'package:dynamische_materialdatenbank/features/material/widgets/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/features/material/providers/material_provider.dart';
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

    final argument = AttributeArgument(
      materialId: materialId,
      attributePath: AttributePath(Attributes.components),
    );
    final value = ref.watch(jsonValueProvider(argument)) ?? [];

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
