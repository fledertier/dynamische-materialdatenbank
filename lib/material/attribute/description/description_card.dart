import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../types.dart';
import '../../edit_mode_button.dart';
import '../../material_service.dart';
import '../attribute_card.dart';

class DescriptionCard extends ConsumerStatefulWidget {
  const DescriptionCard(this.material, {super.key});

  final Json material;

  @override
  ConsumerState<DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends ConsumerState<DescriptionCard> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final value = widget.material[Attributes.description];
    controller = TextEditingController(text: value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(Attributes.description));

    return AttributeCard(
      label: AttributeLabel(label: attribute?.name),
      columns: 2,
      child: TextField(
        enabled: edit,
        style: textTheme.bodyMedium?.copyWith(fontFamily: 'Lexend'),
        decoration: InputDecoration.collapsed(hintText: attribute?.name),
        maxLines: null,
        controller: controller,
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial({
            Attributes.id: widget.material[Attributes.id],
            Attributes.description: value,
          });
        },
      ),
    );
  }
}
