import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/loading_text.dart';
import '../edit_mode_button.dart';

class AttributeCard extends ConsumerStatefulWidget {
  const AttributeCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    required this.child,
    this.onChanged,
  });

  final String? label;
  final String value;
  final String? unit;
  final Widget child;
  final ValueChanged<String>? onChanged;

  @override
  ConsumerState<AttributeCard> createState() => _AttributeCardState();
}

class _AttributeCardState extends ConsumerState<AttributeCard> {
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
    final textTheme = TextTheme.of(context);
    final colorScheme = ColorScheme.of(context);

    final edit = ref.watch(editModeProvider);

    return Container(
      width: 158,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              LoadingText(widget.label, style: textTheme.labelMedium),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  IntrinsicWidth(
                    child: TextField(
                      enabled: edit,
                      style: textTheme.titleLarge?.copyWith(
                        fontFamily: 'Lexend',
                      ),
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
          ),
          widget.child,
        ],
      ),
    );
  }
}
