import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filter/side_sheet.dart';
import '../providers/filter_provider.dart';
import 'condition.dart';
import 'condition_group.dart';

class AdvancedSearch extends ConsumerWidget {
  const AdvancedSearch({super.key, this.onFilters, this.onClose});

  final void Function()? onClose;
  final void Function()? onFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSheet.detached(
      leading: BackButton(onPressed: onFilters),
      title: Text('Advanced search'),
      topActions: [
        IconButton(
          icon: Icon(Icons.refresh),
          tooltip: 'Reset',
          onPressed: () {
            ref.read(filterProvider.notifier).reset();
          },
        ),
        IconButton(
          icon: Icon(Icons.close),
          tooltip: 'Close',
          onPressed: onClose,
        ),
      ],
      width: 800,
      margin: EdgeInsets.zero,
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 24, 24),
              child: ConditionGroupWidget(
                isRootNode: true,
                conditionGroup: ConditionGroup(
                  type: ConditionGroupType.and,
                  nodes: [
                    ConditionGroup(
                      type: ConditionGroupType.or,
                      nodes: [Condition(), Condition()],
                    ),
                    Condition(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
