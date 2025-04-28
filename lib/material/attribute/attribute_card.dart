import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributeCard extends ConsumerWidget {
  const AttributeCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    required this.child,
  });

  final Widget label;
  final Widget value;
  final Widget? unit;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final colorScheme = ColorScheme.of(context);

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
              DefaultTextStyle.merge(
                style: textTheme.labelMedium,
                child: label,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  DefaultTextStyle.merge(
                    style: textTheme.titleLarge?.copyWith(fontFamily: 'Lexend'),
                    child: value,
                  ),
                  if (unit != null)
                    DefaultTextStyle.merge(
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      child: unit!,
                    ),
                ],
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
