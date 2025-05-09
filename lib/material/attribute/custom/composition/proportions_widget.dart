import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../color/color_provider.dart';
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
      height: axis == Axis.horizontal ? height : null,
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
              height: height,
            ),
          if (edit && proportions.length < (maxCount ?? double.infinity))
            IconButton.outlined(
              icon: Icon(Icons.add, size: 18),
              onPressed: () => update(null),
            ),
        ],
      ),
    );
  }
}

class ProportionWidget extends ConsumerWidget {
  const ProportionWidget({
    super.key,
    required this.proportion,
    required this.maxShare,
    required this.axis,
    this.height,
    this.onPressed,
  });

  final Proportion proportion;
  final num maxShare;
  final Axis axis;
  final double? height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    late final color = ref.watch(
      requestingMaterialColorProvider(proportion.name),
    );

    final container = SizedBox(
      height: height,
      child: Material(
        color: proportion.color ?? color ?? colorScheme.surfaceContainerHighest,
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
