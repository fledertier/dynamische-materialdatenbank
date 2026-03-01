import 'package:flutter/material.dart';

class Sheet extends StatelessWidget {
  const Sheet({super.key, this.width, this.child});

  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: ColorScheme.of(context).surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
