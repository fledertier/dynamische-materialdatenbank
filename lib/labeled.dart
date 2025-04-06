import 'package:flutter/material.dart';

class Labeled extends StatelessWidget {
  const Labeled({super.key, required this.label, required this.child});

  final Widget label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.labelMedium,
            child: label,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24).copyWith(top: 0),
          child: child,
        ),
      ],
    );
  }
}
