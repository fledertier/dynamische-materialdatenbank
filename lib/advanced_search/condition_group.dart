import 'package:dynamische_materialdatenbank/advanced_search/condition_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'condition.dart';

class ConditionGroupWidget extends ConsumerWidget {
  const ConditionGroupWidget({
    super.key,
    required this.conditionGroup,
    this.onChanged,
    this.onRemove,
    this.isRootNode = false,
  });

  final ConditionGroup conditionGroup;
  final void Function()? onChanged;
  final void Function()? onRemove;
  final bool isRootNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        if (!(isRootNode && conditionGroup.nodes.isEmpty))
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
              (isRootNode && conditionGroup.nodes.isEmpty)
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
                    onChanged: onChanged,
                    onRemove: () => removeNode(node),
                  )
                else if (node is Condition)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: ConditionWidget(
                      condition: node,
                      onChanged: onChanged,
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
                    (isRootNode && conditionGroup.nodes.isEmpty)
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

  void toggleType() {
    update(() {
      conditionGroup.type = conditionGroup.type.other;
    });
  }

  void addCondition() {
    update(() {
      conditionGroup.nodes.add(Condition());
    });
  }

  void addConditionGroup() {
    update(() {
      conditionGroup.nodes.add(
        ConditionGroup(type: conditionGroup.type.other, nodes: [Condition()]),
      );
    });
  }

  void removeNode(ConditionNode node) {
    update(() {
      conditionGroup.nodes.remove(node);
    });
    if (conditionGroup.nodes.isEmpty) {
      onRemove?.call();
    }
  }

  void update(void Function() update) {
    update();
    onChanged?.call();
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
