import 'package:flutter/material.dart';

import 'material_category.dart';

class CompositionElement extends StatelessWidget {
  const CompositionElement({
    super.key,
    required this.category,
    required this.share,
    this.onPressed,
  });

  final MaterialCategory category;
  final num share;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Flexible(
      flex: share.round(),
      child: Material(
        color: category.color,
        shape: StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                category.name,
                style: textTheme.bodyLarge!.copyWith(
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
  }
}
