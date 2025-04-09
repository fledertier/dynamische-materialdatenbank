import 'package:flutter/material.dart';

class DirectionalMenuAnchor extends StatelessWidget {
  const DirectionalMenuAnchor({
    super.key,
    required this.directionality,
    this.controller,
    this.childFocusNode,
    this.style,
    this.alignmentOffset = Offset.zero,
    this.layerLink,
    this.clipBehavior = Clip.hardEdge,
    this.consumeOutsideTap = false,
    this.onOpen,
    this.onClose,
    this.crossAxisUnconstrained = true,
    required this.menuChildren,
    this.builder,
    this.child,
  });

  final TextDirection directionality;
  final MenuController? controller;
  final FocusNode? childFocusNode;
  final MenuStyle? style;
  final Offset? alignmentOffset;
  final LayerLink? layerLink;
  final Clip clipBehavior;
  final bool consumeOutsideTap;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final bool crossAxisUnconstrained;
  final List<Widget> menuChildren;
  final MenuAnchorChildBuilder? builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: directionality,
      child: MenuAnchor(
        controller: controller,
        childFocusNode: childFocusNode,
        style: style,
        alignmentOffset: alignmentOffset,
        layerLink: layerLink,
        clipBehavior: clipBehavior,
        consumeOutsideTap: consumeOutsideTap,
        onOpen: onOpen,
        onClose: onClose,
        crossAxisUnconstrained: crossAxisUnconstrained,
        menuChildren: [
          for (final menuChild in menuChildren)
            Directionality(textDirection: TextDirection.ltr, child: menuChild),
        ],
        builder: (context, controller, child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child:
                builder?.call(context, controller, child) ??
                child ??
                const SizedBox(),
          );
        },
        child: child,
      ),
    );
  }
}
