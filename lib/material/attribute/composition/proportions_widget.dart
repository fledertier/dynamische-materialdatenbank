import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../composition/proportion.dart';

class ProportionsWidget<T extends Proportion> extends StatelessWidget {
  const ProportionsWidget({
    super.key,
    required this.height,
    required this.axis,
    required this.edit,
    required this.proportions,
    this.maxCount,
    required this.update,
  });

  final double? height;
  final Axis axis;
  final bool edit;
  final List<T> proportions;
  final int? maxCount;
  final void Function(T? proportion) update;

  @override
  Widget build(BuildContext context) {
    final sortedProportions =
        proportions.sortedBy((proportion) => proportion.share).reversed;

    return SizedBox(
      height: height,
      child: Flex(
        direction: axis,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          for (final proportion in sortedProportions)
            ProportionWidget(
              proportion: proportion,
              maxShare: sortedProportions.first.share,
              onPressed: edit ? () => update(proportion) : null,
              axis: axis,
            ),
          if (edit && proportions.length < (maxCount ?? double.infinity))
            IconButton.outlined(
              icon: Icon(Icons.add),
              onPressed: () => update(null),
            ),
        ],
      ),
    );
  }
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
                proportion.name,
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
