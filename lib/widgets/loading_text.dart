import 'package:flutter/material.dart';

class LoadingText extends StatelessWidget {
  const LoadingText(this.data, {super.key, this.style, this.width});

  final String? data;
  final TextStyle? style;
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return Text(data!, style: this.style);
    }
    final style = DefaultTextStyle.of(context).style.merge(this.style);
    final letterHeight = calculateTextHeight(
      context,
      style.copyWith(height: 0.8),
    );
    final width = this.width ?? letterHeight * 8;
    final color = style.color ?? ColorScheme.of(context).onSurface;

    return SizedBox(
      width: width,
      height: calculateTextHeight(context, style),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: width,
          height: letterHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(letterHeight),
              color: color.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    );
  }

  double calculateTextHeight(BuildContext context, TextStyle style) {
    return TextPainter(
      text: TextSpan(style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    ).preferredLineHeight;
  }
}
