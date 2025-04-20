import 'package:dynamische_materialdatenbank/advanced_search/condition_widget.dart';
import 'package:flutter/material.dart';

import 'condition.dart';

class ConditionGroupWidget extends StatefulWidget {
  const ConditionGroupWidget({super.key, required this.conditionGroup});

  final ConditionGroup conditionGroup;

  @override
  State<ConditionGroupWidget> createState() => _ConditionGroupWidgetState();
}

class _ConditionGroupWidgetState extends State<ConditionGroupWidget> {
  late ConditionGroup conditionGroup = widget.conditionGroup;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Stack(
      children: [
        Positioned.fill(
          right: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: HalfBracket.upper()),
              TextButton(
                onPressed: () {
                  setState(() {
                    conditionGroup = conditionGroup.copyWith(
                      type: conditionGroup.type.other,
                    );
                  });
                },
                child:
                    conditionGroup.type == ConditionGroupType.and
                        ? Text("And")
                        : Text("Or"),
              ),
              Expanded(child: HalfBracket.lower()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64 - 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              for (final node in conditionGroup.nodes)
                if (node is ConditionGroup)
                  ConditionGroupWidget(conditionGroup: node)
                else if (node is Condition)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: ConditionWidget(condition: node),
                  )
                else
                  throw Exception("Unknown condition node type"),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Row(
                  spacing: 6,
                  children: [
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          conditionGroup.nodes.add(Condition());
                        });
                      },
                      child:
                          conditionGroup.type == ConditionGroupType.and
                              ? Text("And")
                              : Text("Or"),
                    ),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          conditionGroup.nodes.add(
                            ConditionGroup(
                              type: conditionGroup.type.other,
                              nodes: [Condition(), Condition()],
                            ),
                          );
                        });
                      },
                      child:
                          conditionGroup.type == ConditionGroupType.and
                              ? Text("Or")
                              : Text("And"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
