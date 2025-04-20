import 'package:flutter/material.dart';

class Labeled extends StatelessWidget {
  const Labeled({
    super.key,
    required this.label,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 24),
    this.gap = 16,
  });

  final Widget label;
  final Widget child;
  final EdgeInsets padding;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle.merge(
            style: TextTheme.of(context).labelMedium,
            child: label,
          ),
          SizedBox(height: gap),
          child,
        ],
      ),
    );
  }
}
