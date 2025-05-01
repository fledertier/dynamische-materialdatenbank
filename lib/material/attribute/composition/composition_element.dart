import 'package:flutter/material.dart';

import 'material_category.dart';

// todo: rename to proportion element
class CompositionElement extends StatelessWidget {
  const CompositionElement({
    super.key,
    required this.category,
    required this.share,
    this.alignment = Alignment.center,
    this.onPressed,
  });

  // todo: turn into string
  final MaterialCategory category;
  final num share;
  final Alignment alignment;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Material(
      color: category.color,
      shape: StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: alignment,
            child: Text(
              category.name,
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
    );
  }
}
