import 'package:dynamische_materialdatenbank/advanced_search/condition_widget.dart';
import 'package:flutter/material.dart';

import 'condition.dart';

class ConditionGroupWidget extends StatefulWidget {
  const ConditionGroupWidget({
    super.key,
    required this.conditionGroup,
    this.onRemove,
    this.isRootNode = false,
  });

  final ConditionGroup conditionGroup;
  final void Function()? onRemove;
  final bool isRootNode;

  @override
  State<ConditionGroupWidget> createState() => _ConditionGroupWidgetState();
}

class _ConditionGroupWidgetState extends State<ConditionGroupWidget> {
  late ConditionGroup conditionGroup = widget.conditionGroup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        if (!isRootNode)
          Positioned.fill(
            right: null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: HalfBracket.upper()),
                TextButton(
                  onPressed: toggleType,
                  child: isAnd ? Text("And") : Text("Or"),
                ),
                Expanded(child: HalfBracket.lower()),
              ],
            ),
          ),
        Padding(
          padding:
              isRootNode
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 64 - 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              for (final node in conditionGroup.nodes)
                if (node is ConditionGroup)
                  ConditionGroupWidget(
                    conditionGroup: node,
                    onRemove: () => removeNode(node),
                  )
                else if (node is Condition)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: ConditionWidget(
                      condition: node,
                      onRemove: () => removeNode(node),
                    ),
                  )
                else
                  throw Exception("Unknown condition node type"),
              Theme(
                data: theme.copyWith(
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.08,
                      ),
                    ).merge(theme.textButtonTheme.style),
                  ),
                ),
                child:
                    isRootNode
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            spacing: 6,
                            children: [
                              TextButton(
                                onPressed: () => addCondition(),
                                child: Text(isAnd ? "And" : "Or"),
                              ),
                              TextButton(
                                onPressed: () {
                                  toggleType();
                                  addCondition();
                                },
                                child: Text(isAnd ? "Or" : "And"),
                              ),
                            ],
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Row(
                            spacing: 6,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.add),
                                onPressed: () => addCondition(),
                                label: Text("Condition"),
                              ),
                              TextButton(
                                onPressed: () => addConditionGroup(),
                                child: Text(isAnd ? "Or" : "And"),
                              ),
                            ],
                          ),
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get isAnd => conditionGroup.type == ConditionGroupType.and;

  bool get isRootNode => widget.isRootNode && conditionGroup.nodes.isEmpty;

  void toggleType() {
    setState(() {
      conditionGroup.type = conditionGroup.type.other;
    });
  }

  void addCondition() {
    setState(() {
      conditionGroup.nodes.add(Condition());
    });
  }

  void addConditionGroup() {
    setState(() {
      conditionGroup.nodes.add(
        ConditionGroup(type: conditionGroup.type.other, nodes: [Condition()]),
      );
    });
  }

  void removeNode(ConditionNode node) {
    setState(() {
      conditionGroup.nodes.remove(node);
    });
    if (conditionGroup.nodes.isEmpty) {
      widget.onRemove?.call();
    }
  }
}

class HalfBracket extends StatelessWidget {
  const HalfBracket.upper({super.key, this.width = 20}) : isUpper = true;

  const HalfBracket.lower({super.key, this.width = 20}) : isUpper = false;

  final double width;
  final bool isUpper;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(
      width: 2,
      color: ColorScheme.of(context).primary,
    );

    return Padding(
      padding: EdgeInsets.only(left: width),
      child: SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: borderSide,
              top: isUpper ? borderSide : BorderSide.none,
              bottom: isUpper ? BorderSide.none : borderSide,
            ),
          ),
        ),
      ),
    );
  }
}
