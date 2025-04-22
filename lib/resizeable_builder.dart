import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum HandleAlignment {
  outer(1.0),
  middle(0.5),
  inner(0.0);

  const HandleAlignment(this.value);

  final double value;
}

class ResizeableBuilder extends StatefulWidget {
  const ResizeableBuilder({
    super.key,
    required this.builder,
    required this.minWidth,
    required this.width,
    required this.maxWidth,
    this.handleWidth = 8,
    this.handleAlignment = HandleAlignment.middle,
    this.cursor = SystemMouseCursors.resizeLeftRight,
  });

  final double minWidth;
  final double width;
  final double maxWidth;
  final double handleWidth;
  final HandleAlignment handleAlignment;
  final MouseCursor cursor;
  final Widget Function(BuildContext context, double width) builder;

  @override
  State<ResizeableBuilder> createState() => _ResizeableBuilderState();
}

class _ResizeableBuilderState extends State<ResizeableBuilder> {
  late double width = widget.width;
  late double dragStart = widget.width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: widget.handleWidth * widget.handleAlignment.value,
          ),
          child: widget.builder(context, width),
        ),
        SizedBox(
          width: widget.handleWidth,
          child: GestureDetector(
            onHorizontalDragStart: (details) {
              dragStart = width;
            },
            onHorizontalDragUpdate: (details) {
              final position = dragStart - details.localPosition.dx;
              final clamped = clampDouble(
                position,
                widget.minWidth,
                widget.maxWidth,
              );
              setState(() {
                width = clamped;
              });
            },
            child: MouseRegion(cursor: widget.cursor),
          ),
        ),
      ],
    );
  }
}
