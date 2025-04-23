import 'package:flutter/material.dart';

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({super.key, required this.builder, this.child});

  final ValueWidgetBuilder<bool> builder;
  final Widget? child;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() => hover = true);
      },
      onExit: (event) {
        setState(() => hover = false);
      },
      child: widget.builder(context, hover, widget.child),
    );
  }
}
