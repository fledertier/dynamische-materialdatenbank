import 'package:flutter/material.dart';

typedef Proportion = Map<String, num>;

class ProportionWidget extends StatelessWidget {
  const ProportionWidget({
    super.key,
    required this.label,
    required this.color,
    required this.share,
    required this.maxShare,
    required this.axis,
    this.onPressed,
  });

  final String label;
  final Color color;
  final num share;
  final num maxShare;
  final Axis axis;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    final container = SizedBox(
      height: 40,
      child: Material(
        color: color,
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
                label,
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
      Axis.horizontal => Flexible(flex: share.round(), child: container),
      Axis.vertical => FractionallySizedBox(
        widthFactor: share / maxShare,
        alignment: Alignment.centerLeft,
        child: container,
      ),
    };
  }
}
