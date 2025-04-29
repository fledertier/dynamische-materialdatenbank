import 'package:flutter/material.dart';

class AttributeCard extends StatelessWidget {
  const AttributeCard({
    super.key,
    required this.label,
    required this.child,
    this.columns = 1,
  });

  final Widget label;
  final Widget child;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: columns * 158 + (columns - 1) * 16,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [label, child],
      ),
    );
  }
}
