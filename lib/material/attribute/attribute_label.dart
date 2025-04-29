import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/loading_text.dart';
import '../edit_mode_button.dart';

class AttributeLabel extends ConsumerStatefulWidget {
  const AttributeLabel({
    super.key,
    required this.label,
    this.value,
    this.unit,
    this.onChanged,
  });

  final String? label;
  final String? value;
  final String? unit;
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

    final edit = ref.watch(editModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        LoadingText(widget.label, style: textTheme.labelMedium),
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
              if (widget.unit != null)
                Text(
                  widget.unit!,
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
