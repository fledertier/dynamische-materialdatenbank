import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';

import '../../material/attribute/cards.dart';
import 'animated_draggable.dart';
import 'local_hero_overlay.dart';

class ReorderableCardSection extends StatefulWidget {
  const ReorderableCardSection({
    super.key,
    required this.cards,
    this.animationDuration = const Duration(milliseconds: 250),
    required this.itemBuilder,
    this.decorator,
    this.onReorder,
    this.trailing,
  });

  final List<CardData> cards;
  final Duration animationDuration;
  final IndexedWidgetBuilder itemBuilder;
  final Widget Function(BuildContext context, Widget child)? decorator;
  final void Function(CardData source, CardData target)? onReorder;
  final Widget? trailing;

  @override
  State<ReorderableCardSection> createState() => _ReorderableFilesGrid();
}

class _ReorderableFilesGrid extends State<ReorderableCardSection> {
  var _scopeKey = UniqueKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LocalHeroScope(
      // key: _scopeKey,
      duration: widget.animationDuration,
      createRectTween: (begin, end) {
        return RectTween(begin: begin, end: end);
      },
      curve: Curves.easeInOut,
      child: LocalHeroOverlay(
        clip: Clip.none,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ...List.generate(widget.cards.length, (index) => _buildItem(index)),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final data = widget.cards.elementAtOrNull(index);
    if (data == null) {
      return widget.itemBuilder(context, index);
    }
    return DragTarget<CardData>(
      key: ValueKey(data),
      onWillAcceptWithDetails: (details) {
        final accept = details.data != data;
        if (accept) {
          onDrag(details.data, data);
        }
        return accept;
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedDraggable<CardData>(
          data: data,
          onDragEnd: (details) {
            // Future.delayed(widget.animationDuration, _resetScope);
          },
          feedbackBuilder: (child) {
            return widget.decorator?.call(context, child) ??
                _defaultDecorator(context, child);
          },
          child: widget.itemBuilder(context, index),
        );
      },
    );
  }

  void onDrag(CardData source, CardData target) {
    widget.onReorder?.call(source, target);
    setState(() {});
  }

  void _resetScope() {
    setState(() {
      _scopeKey = UniqueKey();
    });
  }
}

Widget _defaultDecorator(BuildContext context, Widget child) {
  return Material(
    borderRadius: BorderRadius.circular(16),
    elevation: 8,
    child: child,
  );
}
