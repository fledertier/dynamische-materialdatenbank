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
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.labelMedium,
            child: label,
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
