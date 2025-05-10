import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../attributes/attribute_provider.dart';
import '../../widgets/loading_text.dart';
import '../edit_mode_button.dart';

class AttributeLabel extends ConsumerStatefulWidget {
  const AttributeLabel({
    super.key,
    required this.attribute,
    this.value,
    this.onChanged,
  });

  final String attribute;
  final String? value;
  final ValueChanged<String>? onChanged;

  @override
  ConsumerState<AttributeLabel> createState() => _AttributeLabelState();
}

class _AttributeLabelState extends ConsumerState<AttributeLabel> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    final attribute = ref.watch(attributeProvider(widget.attribute));
    final edit = ref.watch(editModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        LoadingText(attribute?.name, style: textTheme.labelMedium),
        if (widget.value != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              IntrinsicWidth(
                child: TextField(
                  enabled: edit,
                  style: textTheme.titleLarge?.copyWith(fontFamily: 'Lexend'),
                  decoration: InputDecoration.collapsed(hintText: '0'),
                  controller: controller,
                  onChanged: widget.onChanged,
                ),
              ),
              if (attribute?.unitType != null)
                Text(
                  attribute!.unitType!.base,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
