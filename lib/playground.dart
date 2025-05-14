import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TransformDragWrap()));

class TransformDragWrap extends StatefulWidget {
  @override
  State<TransformDragWrap> createState() => _TransformDragWrapState();
}

class _TransformDragWrapState extends State<TransformDragWrap>
    with TickerProviderStateMixin {
  final List<int> items = List.generate(6, (i) => i);

  int? snappingItem;
  Offset currentOffset = Offset.zero;

  late final AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void startSnapBack() {
    _animation = Tween<Offset>(
      begin: currentOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0);
  }

  Widget buildItem(int item) {
    final draggable = Draggable<int>(
      data: item,
      onDragStarted: () {
        currentOffset = Offset.zero;
      },
      onDragUpdate: (details) {
        currentOffset += details.delta;
      },
      onDragEnd: (details) {
        setState(() {
          snappingItem = item;
        });
        startSnapBack();
      },
      feedback: Material(
        color: Colors.transparent,
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: itemBox(item),
      ),
      childWhenDragging: Opacity(opacity: 0, child: itemBox(item)),
      child: itemBox(item),
    );

    if (item == snappingItem) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(offset: _animation.value, child: child);
        },
        child: draggable,
      );
    }
    return draggable;
  }

  Widget itemBox(int item) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("Item $item", style: TextStyle(color: Colors.white)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map(buildItem).toList(),
        ),
      ),
    );
  }
}
