import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fire_behavior_standard.dart';
import 'fire_behavior_standard_visualization.dart';

class FireBehaviorStandardCard extends ConsumerStatefulWidget {
  const FireBehaviorStandardCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  ConsumerState<FireBehaviorStandardCard> createState() =>
      _FireBehaviorStandardCardState();
}

class _FireBehaviorStandardCardState
    extends ConsumerState<FireBehaviorStandardCard> {
  // late TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final translatableText =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: widget.materialId,
                  attributeId: Attributes.fireBehaviorStandard,
                ),
              ),
            )
            as TranslatableText?;

    final classification = translatableText?.valueDe ?? 'B-s2,d1';
    final fireBehavior = FireBehaviorStandard.parse(classification);

    return AttributeCard(
      columns: 3,
      label: AttributeLabel(attributeId: Attributes.fireBehaviorStandard),
      title: TextFormField(
        enabled: edit,
        style: TextTheme.of(context).titleLarge?.copyWith(fontFamily: 'Lexend'),
        decoration: InputDecoration.collapsed(hintText: 'z.B. B-s2,d1'),
        initialValue: classification,
        // controller: controller ??= TextEditingController(text: classification),
        onChanged: (value) {
          ref.read(materialProvider(widget.materialId).notifier).updateMaterial(
            {Attributes.fireBehaviorStandard: value},
          );
        },
      ),
      child: FireBehaviorStandardVisualization(fireBehavior),
    );
  }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }
}
