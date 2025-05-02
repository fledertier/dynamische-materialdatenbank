import 'package:flutter/material.dart';

class Proportion {
  const Proportion({
    required this.label,
    required this.color,
    required this.share,
  });

  final String label;
  final Color color;
  final num share;
}

class ProportionWidget extends StatelessWidget {
  const ProportionWidget({
    super.key,
    required this.proportion,
    required this.maxShare,
    required this.axis,
    this.onPressed,
  });

  final Proportion proportion;
  final num maxShare;
  final Axis axis;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    final container = SizedBox(
      height: 40,
      child: Material(
        color: proportion.color,
        shape: StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: switch (axis) {
                Axis.horizontal => Alignment.center,
                Axis.vertical => Alignment.centerLeft,
              },
              child: Text(
                proportion.label,
                style: textTheme.bodyMedium!.copyWith(
                  fontFamily: 'Lexend',
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );

    return switch (axis) {
      Axis.horizontal => Flexible(
        flex: proportion.share.round(),
        child: container,
      ),
      Axis.vertical => FractionallySizedBox(
        widthFactor: proportion.share / maxShare,
        alignment: Alignment.centerLeft,
        child: container,
      ),
    };
  }
}
