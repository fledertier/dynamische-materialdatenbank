import 'package:flutter/widgets.dart';
import 'package:local_hero/local_hero.dart';

class AnimatedDraggable<T extends Object> extends StatelessWidget {
  const AnimatedDraggable({
    super.key,
    required this.data,
    required this.child,
    this.onDragStarted,
    this.onDragEnd,
    this.feedbackBuilder,
    this.offset,
  });

  final T data;
  final Widget child;
  final void Function()? onDragStarted;
  final void Function(DraggableDetails details)? onDragEnd;
  final Widget Function(Widget child)? feedbackBuilder;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return Draggable<T>(
      onDragStarted: () {
        onDragStarted?.call();
      },
      onDragEnd: (details) {
        onDragEnd?.call(details);
      },
      data: data,
      dragAnchorStrategy:
          offset != null
              ? (draggable, context, position) => offset!
              : childDragAnchorStrategy,
      feedback: LocalHero(
        tag: data,
        child: feedbackBuilder?.call(child) ?? child,
      ),
      childWhenDragging: Opacity(opacity: 0, child: child),
      child: LocalHero(tag: data, child: child),
    );
  }
}
