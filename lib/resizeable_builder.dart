import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HandleAlignment {
  static const left = HandleAlignment(0.0);
  static const center = HandleAlignment(0.5);
  static const right = HandleAlignment(1.0);

  const HandleAlignment(this.x);

  final double x;
}

class ResizeableBuilder extends StatefulWidget {
  const ResizeableBuilder({
    super.key,
    required this.builder,
    required this.minWidth,
    required this.width,
    required this.maxWidth,
    this.handleWidth = 8,
    this.handleAlignment = HandleAlignment.center,
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
            left: widget.handleWidth * widget.handleAlignment.x,
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
