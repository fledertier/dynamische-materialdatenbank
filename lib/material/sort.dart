import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';
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
      tooltip:
          direction == SortDirection.ascending ? 'ascending' : 'descending',
    );
  }
}

final sortDirectionProvider = StateProvider<SortDirection>((ref) {
  return SortDirection.ascending;
});

enum SortDirection {
  ascending,
  descending;

  SortDirection get other {
    return this == SortDirection.ascending
        ? SortDirection.descending
        : SortDirection.ascending;
  }
}

class SortAttributeSelector extends ConsumerWidget {
  const SortAttributeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(sortAttributeProvider);
    final attributesById = ref.watch(attributesProvider).value ?? {};
    final attributes = attributesById.values.sortedBy(
      (attribute) => attribute.name ?? attribute.type.name.toTitleCase(),
    );
    final attribute = getAttribute(attributesById, id);
    final name = getFullAttributeName(attributesById, id)?.join(' / ');

    return MenuAnchor(
      builder: (context, controller, child) {
        return TextButton(
          onPressed: controller.toggle,
          child: Text(attribute != null ? 'by $name' : 'Sort by'),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            ref.read(sortAttributeProvider.notifier).state = null;
          },
          child: Text('Nothing'),
        ),
        for (final attribute in attributes) buildMenu(ref, attribute, []),
      ],
    );
  }

  Widget buildMenu(WidgetRef ref, Attribute attribute, List<String> path) {
    final currentPath = [...path, attribute.id];
    final type = attribute.type;
    final name = attribute.name ?? type.name.toTitleCase();

    if (type is ObjectAttributeType) {
      return SubmenuButton(
        menuChildren: [
          for (final child in type.attributes)
            buildMenu(ref, child, currentPath),
        ],
        child: Text(name),
      );
    } else if (type is ListAttributeType) {
      final child = type.attribute;
      final menu = buildMenu(ref, child, currentPath);
      return switch (menu) {
        final SubmenuButton submenu => SubmenuButton(
          menuChildren: submenu.menuChildren,
          child: Text(name),
        ),
        final MenuItemButton item => MenuItemButton(
          onPressed: item.onPressed,
          child: Text(name),
        ),
        _ => throw UnimplementedError(),
      };
    } else {
      return MenuItemButton(
        onPressed: () {
          final id = currentPath.join('.');
          ref.read(sortAttributeProvider.notifier).state = id;
        },
        child: Text(name),
      );
    }
  }
}

final sortAttributeProvider = StateProvider<String?>((ref) {
  return null;
});
