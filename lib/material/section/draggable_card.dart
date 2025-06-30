import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:flutter/material.dart';

class DraggableCard extends StatefulWidget {
  const DraggableCard({
    super.key,
    required this.data,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onDragStarted,
    this.onDragEnd,
    this.onDragCompleted,
    required this.child,
  });

  final CardData data;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;
  final VoidCallback? onDragCompleted;
  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Draggable<CardData>(
      data: widget.data,
      maxSimultaneousDrags: 1,
      onDragStarted: widget.onDragStarted,
      onDragUpdate: (details) {
        if (!isDragging) {
          isDragging = true;
          widget.onDragStarted?.call();
        }
      },
      onDragEnd: (details) {
        isDragging = false;
        widget.onDragEnd?.call();
      },
      onDragCompleted: widget.onDragCompleted,
      feedback: Padding(
        padding: widget.padding,
        child: Material(
          color: Colors.transparent,
          borderRadius: widget.borderRadius,
          elevation: 8,
          child: widget.child,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0,
        child: Padding(padding: widget.padding, child: widget.child),
      ),
      child: Padding(padding: widget.padding, child: widget.child),
    );
  }
}
