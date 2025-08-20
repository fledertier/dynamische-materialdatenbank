import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/fire_behavior/fire_behavior_standard.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/fire_behavior/fire_behavior_standard_visualization.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FireBehaviorStandardCard extends ConsumerWidget {
  const FireBehaviorStandardCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final text =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: materialId,
                  attributePath: AttributePath(Attributes.fireBehaviorStandard),
                ),
              ),
            )
            as TranslatableText?;

    String? validate(String? classification) {
      if (classification == null || classification.isEmpty) {
        return null;
      }
      if (!edit) {
        return null;
      }
      if (!FireBehaviorStandard.isValid(classification)) {
        return 'Invalid classification';
      }
      return null;
    }

    final classification = text?.value;
    final fireBehavior = FireBehaviorStandard.tryParse(classification ?? '');
    final error = validate(classification);

    return AttributeCard(
      columns: 3,
      label: AttributeLabel(attributeId: Attributes.fireBehaviorStandard),
      title: TextFormField(
        key: ValueKey(classification == null),
        enabled: edit,
        style: TextTheme.of(context).titleLarge?.copyWith(fontFamily: 'Lexend'),
        decoration: InputDecoration.collapsed(hintText: 'z.B. B-s2,d1'),
        initialValue: classification,
        onChanged: (value) {
          ref.read(materialProvider(materialId).notifier).updateMaterial({
            Attributes.fireBehaviorStandard: TranslatableText.fromValue(
              value,
            ).toJson(),
          });
        },
      ),
      child: fireBehavior != null
          ? FireBehaviorStandardVisualization(fireBehavior)
          : error != null
          ? Text(
              error,
              style: TextTheme.of(
                context,
              ).bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            )
          : null,
    );
  }
}
