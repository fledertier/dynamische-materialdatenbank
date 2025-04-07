import 'package:flutter/material.dart';

class SideSheet extends StatelessWidget {
  const SideSheet.docked({
    super.key,
    this.title,
    this.child,
    this.topActions,
    this.bottomActions,
    this.width = 256,
  }) : borderRadius = BorderRadius.zero,
       margin = EdgeInsets.zero,
       docked = true;

  const SideSheet.detached({
    super.key,
    this.title,
    this.child,
    this.topActions,
    this.bottomActions,
    this.width = 256,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.margin = const EdgeInsets.all(16),
  }) : docked = false;

  final Widget? title;
  final Widget? child;
  final List<Widget>? topActions;
  final List<Widget>? bottomActions;
  final double? width;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry margin;
  final bool docked;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final containerColor =
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
          color: containerColor,
          borderRadius: borderRadius,
          border:
              docked
                  ? Border(left: BorderSide(color: colorScheme.outline))
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 76,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 12),
                child: Row(
                  children: [
                    if (title != null)
                      DefaultTextStyle.merge(
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        child: title!,
                      ),
                    const Spacer(),
                    if (topActions != null)
                      IconTheme.merge(
                        data: IconThemeData(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        child: Row(children: topActions!),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: containerColor,
                child: SingleChildScrollView(child: child),
              ),
            ),
            if (bottomActions != null)
              Container(
                padding: const EdgeInsets.all(24).copyWith(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  children: [
                    for (final action in bottomActions!) ...[
                      if (!identical(action, bottomActions!.first))
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
