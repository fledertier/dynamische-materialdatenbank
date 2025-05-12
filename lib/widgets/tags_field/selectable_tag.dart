import 'package:flutter/material.dart';

class SelectableTag extends StatelessWidget {
  const SelectableTag({
    super.key,
    required this.selected,
    this.avatar,
    required this.label,
    this.onTap,
    this.backgroundColor = Colors.transparent,
  });

  final bool selected;
  final Widget? avatar;
  final Widget label;
  final VoidCallback? onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: selected ? backgroundColor : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: ChipTheme(
          data: ChipTheme.of(context).copyWith(
            side: BorderSide(
              color:
                  selected
                      ? Colors.transparent
                      : ColorScheme.of(context).outlineVariant,
            ),
            backgroundColor:
                selected ? ColorScheme.of(context).secondaryContainer : null,
          ),
          child:
              onTap != null
                  ? ActionChip(avatar: avatar, label: label, onPressed: onTap)
                  : Chip(avatar: avatar, label: label),
        ),
      ),
    );
  }
}
