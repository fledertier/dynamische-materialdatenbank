import 'package:flutter/material.dart';

class SideSheet extends StatelessWidget {
  const SideSheet.docked({
    super.key,
    this.title,
    this.child,
    this.topActions,
    this.bottomActions,
    this.width = 256,
    this.showBottomDivider = false,
  }) : borderRadius = BorderRadius.zero,
       margin = EdgeInsets.zero,
       showDivider = true;

  const SideSheet.detached({
    super.key,
    this.title,
    this.child,
    this.topActions,
    this.bottomActions,
    this.width = 256,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.margin = const EdgeInsets.all(16),
    this.showBottomDivider = false,
  }) : showDivider = false;

  final Widget? title;
  final Widget? child;
  final List<Widget>? topActions;
  final List<Widget>? bottomActions;
  final double? width;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry margin;
  final bool showDivider;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: margin,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: borderRadius,
        border: Border(
          left:
              showDivider
                  ? BorderSide(color: colorScheme.outline)
                  : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 76,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 18),
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
                    IconButtonTheme(
                      data: IconButtonThemeData(
                        style: IconButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                          visualDensity: VisualDensity.comfortable,
                          padding: EdgeInsets.zero,
                        ).merge(IconButtonTheme.of(context).style),
                      ),
                      child: Row(children: topActions!),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: colorScheme.surface,
              child: ListTileTheme(
                controlAffinity: ListTileControlAffinity.leading,
                style: ListTileStyle.drawer,
                horizontalTitleGap: 4,
                child: SingleChildScrollView(child: child),
              ),
            ),
          ),
          if (bottomActions != null)
            Container(
              padding: const EdgeInsets.all(24).copyWith(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top:
                      showBottomDivider
                          ? BorderSide(color: colorScheme.outlineVariant)
                          : BorderSide.none,
                ),
              ),
              child: Row(
                spacing: 8,
                children: bottomActions!,
              ),
            ),
        ],
      ),
    );
  }
}
