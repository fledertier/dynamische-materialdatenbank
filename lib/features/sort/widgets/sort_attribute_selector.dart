import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_type.dart';
import 'package:dynamische_materialdatenbank/features/attributes/providers/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/features/sort/providers/sort_providers.dart';
import 'package:dynamische_materialdatenbank/shared/utils/attribute_utils.dart';
import 'package:dynamische_materialdatenbank/shared/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/shared/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SortAttributeSelector extends ConsumerWidget {
  const SortAttributeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(sortAttributeProvider);
    final attributesById = ref.watch(attributesProvider).valueOrNull ?? {};
    final attributes = attributesById.values.sortedBy(
      (attribute) => attribute.name ?? attribute.type.name.toTitleCase(),
    );
    final attribute = getAttribute(attributesById, path);
    final name = getFullAttributeName(attributesById, path)?.join(' / ');

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
          final path = AttributePath.of(currentPath);
          ref.read(sortAttributeProvider.notifier).state = path;
        },
        child: Text(name),
      );
    }
  }
}
