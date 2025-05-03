import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../color/color_provider.dart';
import 'component.dart';

class ComponentsList extends StatelessWidget {
  const ComponentsList({
    super.key,
    required this.edit,
    required this.components,
    required this.update,
  });

  final bool edit;
  final List<Component> components;
  final void Function(Component? component) update;

  @override
  Widget build(BuildContext context) {
    final sortedComponents =
        components.sortedBy((component) => component.share).reversed;

    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: widthByColumns(3),
        mainAxisExtent: 72,
      ),
      shrinkWrap: true,
      children: [
        for (final component in sortedComponents)
          ComponentTile(
            edit: edit,
            component: component,
            onTap: () => update(component),
          ),
        if (edit)
          Padding(
            padding: const EdgeInsets.all(16),
            child: IconButton.outlined(
              icon: Icon(Icons.add, size: 18),
              onPressed: () => update(null),
            ),
          ),
      ],
    );
  }
}

class ComponentTile extends ConsumerWidget {
  const ComponentTile({
    super.key,
    required this.edit,
    required this.component,
    required this.onTap,
  });

  final bool edit;
  final Component component;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final color = ref.watch(materialColorProvider(component.name));

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color ?? colorScheme.surfaceContainerHighest,
        ),
        title: Text(component.name),
        subtitle: Text('${component.share} %'),
        onTap: edit ? onTap : null,
      ),
    );
  }
}
