import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../types.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../cards.dart';

class TextCard extends ConsumerStatefulWidget {
  const TextCard({
    super.key,
    required this.material,
    required this.attribute,
    required this.size,
    this.textStyle,
  });

  final Json material;
  final String attribute;
  final CardSize size;
  final TextStyle? textStyle;

  @override
  ConsumerState<TextCard> createState() => _TextAreaCardState();
}

class _TextAreaCardState extends ConsumerState<TextCard> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attribute = ref.watch(attributeProvider(widget.attribute));

    return AttributeCard(
      label: AttributeLabel(
        label: attribute?.name,
        value: widget.material[widget.attribute],
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(widget.material, {
            widget.attribute: value,
          });
        },
      ),
    );
  }
}
