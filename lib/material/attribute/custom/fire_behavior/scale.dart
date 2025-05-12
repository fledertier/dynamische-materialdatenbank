import 'package:flutter/material.dart';

class Scale<T> extends StatelessWidget {
  const Scale({
    super.key,
    required this.value,
    required this.values,
    required this.icon,
    this.spacing = 0,
  });

  final T value;
  final List<T> values;
  final Widget icon;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return Wrap(
      spacing: spacing,
      children: [
        for (var i = 1; i < values.length; i++)
          IconTheme.merge(
            data: IconThemeData(
              size: 48,
              fill: 1,
              color:
                  i <= values.indexOf(value)
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
            ),
            child: icon,
          ),
      ],
    );
  }
}
