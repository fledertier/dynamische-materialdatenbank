import 'dart:ui';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../query/condition_group.dart';
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
  final promptController = TextEditingController();

  CancelableOperation<ConditionGroup?>? operation;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final query = ref.watch(advancedSearchQueryProvider).query;

    return ResizableBuilder(
      minWidth: 320,
      width: 600,
      maxWidth: screenSize.width - 300,
      builder: (context, width) {
        return SideSheet(
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
              onPressed: clearQuery,
            ),
            IconButton(
              icon: Icon(Icons.close),
              tooltip: 'Close',
              onPressed: widget.onClose,
            ),
          ],
          width: width,
          bottomActions: [
            Expanded(
              child: MaterialPrompt(
                controller: promptController,
                onQuery: onQuery,
              ),
            ),
          ],
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 24, 24),
              child: Form(
                child: Stack(
                  children: [
                    ImageFiltered(
                      enabled: isLoading,
                      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: ConditionGroupWidget(
                        key: queryKey,
                        isRootNode: true,
                        conditionGroup: query,
                        onChanged: updateQuery,
                      ),
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void updateQuery() {
    ref.read(advancedSearchQueryProvider.notifier).update();
  }

  void setQuery(ConditionGroup query) {
    queryKey = UniqueKey();
    ref.read(advancedSearchQueryProvider.notifier).query = query;
  }

  void clearQuery() {
    queryKey = UniqueKey();
    ref.read(advancedSearchQueryProvider.notifier).reset();
    promptController.clear();
  }

  void onQuery(CancelableOperation<ConditionGroup?> operation) {
    operation.then(
      (query) {
        setState(() {
          isLoading = false;
        });
        if (query != null) {
          setQuery(query);
        }
      },
      onCancel: () {
        setState(() {
          isLoading = false;
        });
      },
      onError: (error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        showError(error);
      },
    );
    setState(() {
      isLoading = true;
      this.operation = operation;
    });
  }

  void showError(Object error) {
    debugPrint('Error: $error');
    Future.microtask(() {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context, // ignore: use_build_context_synchronously
      ).showSnackBar(SnackBar(content: Text('Es ist ein Fehler aufgetreten')));
    });
  }
}
