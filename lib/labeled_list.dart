import 'package:flutter/material.dart';

class LabeledList extends StatelessWidget {
  const LabeledList({super.key, required this.label, required this.children});

  final Widget label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.labelMedium,
            child: label,
          ),
        ),
        SizedBox(height: 8),
        ...children,
        SizedBox(height: 8),
      ],
    );
  }
}
