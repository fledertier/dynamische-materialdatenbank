import 'package:flutter/material.dart';

import '../../material/attribute/cards.dart';

class DraggableCard extends StatelessWidget {
  const DraggableCard({
    super.key,
    required this.data,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onDragStarted,
    this.onDragEnd,
    required this.child,
  });

  final CardData data;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<CardData>(
      data: data,
      delay: Duration(milliseconds: 300),
      maxSimultaneousDrags: 1,
      onDragStarted: onDragStarted,
      onDragEnd: (details) => onDragEnd?.call(),
      feedback: Padding(
        padding: padding,
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          elevation: 8,
          child: child,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0,
        child: Padding(padding: padding, child: child),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
