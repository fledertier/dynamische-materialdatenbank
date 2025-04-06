import 'package:flutter/material.dart';

class SideSheet extends StatelessWidget {
  const SideSheet.docked({
    super.key,
    required this.title,
    required this.children,
    this.actions,
    this.width = 256,
  }) : borderRadius = BorderRadius.zero,
       margin = EdgeInsets.zero,
       docked = true;

  const SideSheet.detached({
    super.key,
    required this.title,
    required this.children,
    this.actions,
    this.width = 256,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.margin = const EdgeInsets.all(16),
  }) : docked = false;

  final Widget title;
  final List<Widget> children;
  final List<Widget>? actions;
  final double? width;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry margin;
  final bool docked;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final color =
        docked ? colorScheme.surface : colorScheme.surfaceContainerLow;

    return ListTileTheme(
      controlAffinity: ListTileControlAffinity.leading,
      style: ListTileStyle.drawer,
      horizontalTitleGap: 4,
      child: Container(
        margin: margin,
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border:
              docked
                  ? Border(left: BorderSide(color: colorScheme.outline))
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: DefaultTextStyle.merge(
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                child: title,
              ),
            ),
            Expanded(
              child: Material(
                color: color,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            ),
            if (actions != null)
              Container(
                padding: const EdgeInsets.all(24).copyWith(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  children: [
                    for (final action in actions!) ...[
                      if (!identical(action, actions!.first))
                        SizedBox(width: 8),
                      action,
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
