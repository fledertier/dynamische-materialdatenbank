import 'package:dynamische_materialdatenbank/features/sort/models/sort_direction.dart';
import 'package:dynamische_materialdatenbank/features/sort/providers/sort_providers.dart';
import 'package:dynamische_materialdatenbank/features/sort/widgets/sort_attribute_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SortButton extends StatelessWidget {
  const SortButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [const SortAttributeSelector(), const SortDirectionButton()],
    );
  }
}

class SortDirectionButton extends ConsumerWidget {
  const SortDirectionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(sortDirectionProvider);
    return IconButton(
      icon: Icon(
        direction == SortDirection.ascending
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        size: 18,
        color: ColorScheme.of(context).primary,
      ),
      onPressed: () {
        ref.read(sortDirectionProvider.notifier).state = direction.other;
      },
      tooltip: direction == SortDirection.ascending
          ? 'ascending'
          : 'descending',
    );
  }
}
