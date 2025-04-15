import 'package:flutter/material.dart';

class LoadingText extends StatelessWidget {
  const LoadingText(this.data, {super.key, this.width});

  final String? data;
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return Text(data!);
    }
    final defaultStyle = DefaultTextStyle.of(context).style;
    final letterHeight = calculateTextHeight(
      context,
      defaultStyle.copyWith(height: 0.8),
    );
    return SizedBox(
      height: calculateTextHeight(context, defaultStyle),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: width ?? letterHeight * 8,
          height: letterHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(letterHeight),
              color: (defaultStyle.color ?? ColorScheme.of(context).onSurface)
                  .withValues(alpha: 0.2),
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
