import 'package:flutter/material.dart';

class LabeledList extends StatelessWidget {
  const LabeledList({
    super.key,
    required this.label,
    required this.children,
    this.gap = 8,
  });

  final Widget label;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: DefaultTextStyle.merge(
              style: TextTheme.of(context).labelMedium,
              child: label,
            ),
          ),
          SizedBox(height: gap),
          ...children,
        ],
      ),
    );
  }
}
