import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/material.dart';

class AttributeCard extends StatelessWidget {
  const AttributeCard({
    super.key,
    this.label,
    this.child,
    this.columns = 1,
    this.labelPadding = const EdgeInsets.all(16),
    this.childPadding = const EdgeInsets.all(16),
    this.spacing = 16,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.clip = Clip.none,
  });

  final Widget? label;
  final Widget? child;
  final int columns;
  final EdgeInsets labelPadding;
  final EdgeInsets childPadding;
  final double spacing;
  final BorderRadius borderRadius;
  final Clip clip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthByColumns(columns),
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainerLow,
        borderRadius: borderRadius,
      ),
      clipBehavior: clip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: spacing,
        children: [
          if (label != null)
            Padding(
              padding:
                  child == null
                      ? labelPadding
                      : labelPadding.copyWith(bottom: 0),
              child: label,
            ),
          if (child != null)
            Padding(
              padding:
                  label == null ? childPadding : childPadding.copyWith(top: 0),
              child: child,
            ),
        ],
      ),
    );
  }
}
