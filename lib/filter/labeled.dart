import 'package:flutter/material.dart';

class Labeled extends StatelessWidget {
  const Labeled({
    super.key,
    required this.label,
    required this.child,
    this.gap = 16,
  });

  final Widget label;
  final Widget child;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24).copyWith(top: 16),
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
