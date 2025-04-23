import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filter/side_sheet.dart';
import '../query/query_source_provider.dart';
import '../resizeable_builder.dart';
import 'advanced_search_provider.dart';
import 'condition_group.dart';

class AdvancedSearch extends ConsumerWidget {
  const AdvancedSearch({super.key, this.onClose});

  final void Function()? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final query = ref.watch(advancedSearchQueryProvider).query;

    return ResizeableBuilder(
      minWidth: 320,
      width: 600,
      maxWidth: screenSize.width - 300,
      builder: (context, width) {
        return SideSheet.detached(
          leading: BackButton(
            onPressed: () {
              ref.read(querySourceProvider.notifier).state =
                  QuerySource.searchAndFilter;
            },
          ),
          title: Text('Advanced search'),
          topActions: [
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Reset',
              onPressed: () {
                ref.read(advancedSearchQueryProvider.notifier).reset();
              },
            ),
            IconButton(
              icon: Icon(Icons.close),
              tooltip: 'Close',
              onPressed: onClose,
            ),
          ],
          bottomActions: [
            FilledButton(onPressed: () {}, child: Text('Run query')),
          ],
          width: width,
          margin: EdgeInsets.zero,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 24, 24),
              child: Form(
                onChanged: () {
                  ref.read(advancedSearchQueryProvider.notifier).update();
                },
                child: ConditionGroupWidget(
                  isRootNode: true,
                  conditionGroup: query,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
