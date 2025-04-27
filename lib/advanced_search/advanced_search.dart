import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../query/query_source_provider.dart';
import '../widgets/resizable_builder.dart';
import '../widgets/side_sheet.dart';
import 'advanced_search_provider.dart';
import 'condition_group_widget.dart';
import 'material_prompt.dart';

class AdvancedSearch extends ConsumerStatefulWidget {
  const AdvancedSearch({super.key, this.onClose});

  final void Function()? onClose;

  @override
  ConsumerState<AdvancedSearch> createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends ConsumerState<AdvancedSearch> {
  Key queryKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final query = ref.watch(advancedSearchQueryProvider).query;

    return ResizableBuilder(
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
                queryKey = UniqueKey();
                ref.read(advancedSearchQueryProvider.notifier).reset();
              },
            ),
            IconButton(
              icon: Icon(Icons.close),
              tooltip: 'Close',
              onPressed: widget.onClose,
            ),
          ],
          width: width,
          margin: EdgeInsets.zero,
          bottomActions: [
            Expanded(
              child: MaterialPrompt(
                onQuery: (query) {
                  queryKey = UniqueKey();
                  ref.read(advancedSearchQueryProvider.notifier).query = query;
                },
              ),
            ),
          ],
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 24, 24),
              child: Form(
                child: ConditionGroupWidget(
                  key: queryKey,
                  isRootNode: true,
                  conditionGroup: query,
                  onChanged: () {
                    ref.read(advancedSearchQueryProvider.notifier).update();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
