import 'package:dynamische_materialdatenbank/widgets/sheet.dart';
import 'package:flutter/material.dart';

class SideSheet extends StatelessWidget {
  const SideSheet({
    super.key,
    this.title,
    this.child,
    this.leading,
    this.topActions,
    this.bottomActions,
    this.width = 256,
  });

  final Widget? title;
  final Widget? child;
  final Widget? leading;
  final List<Widget>? topActions;
  final List<Widget>? bottomActions;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = ColorScheme.of(context);
    final iconButtonTheme = IconButtonTheme.of(context);

    return Sheet(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 76,
            child: Padding(
              padding: EdgeInsets.only(
                left: leading != null ? 4 : 24,
                right: 18,
              ),
              child: Row(
                children: [
                  if (leading != null)
                    IconButtonTheme(
                      data: IconButtonThemeData(
                        style: IconButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                          tapTargetSize: MaterialTapTargetSize.padded,
                        ).merge(iconButtonTheme.style),
                      ),
                      child: leading!,
                    ),
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
                        ).merge(iconButtonTheme.style),
                      ),
                      child: Row(children: topActions!),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Material(
              type: MaterialType.transparency,
              child: ListTileTheme(
                controlAffinity: ListTileControlAffinity.leading,
                style: ListTileStyle.drawer,
                horizontalTitleGap: 4,
                child: SingleChildScrollView(
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            ),
          ),
          if (bottomActions != null)
            Padding(
              padding: const EdgeInsets.all(24).copyWith(top: 16),
              child: Row(spacing: 8, children: bottomActions!),
            ),
        ],
      ),
    );
  }
}
