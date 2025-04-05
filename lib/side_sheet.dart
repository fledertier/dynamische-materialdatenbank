import 'package:flutter/material.dart';

class SideSheet extends StatelessWidget {
  const SideSheet({super.key, required this.title, required this.children});

  final Widget title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      controlAffinity: ListTileControlAffinity.leading,
      style: ListTileStyle.drawer,
      child: Container(
        width: 256,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: DefaultTextStyle.merge(
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: title,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
