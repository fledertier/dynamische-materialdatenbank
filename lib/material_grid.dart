import 'package:dynamische_materialdatenbank/hover_builder.dart';
import 'package:dynamische_materialdatenbank/query/query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';
import 'services/material_service.dart';

class MaterialGrid extends StatelessWidget {
  const MaterialGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final items = ref.watch(queriedMaterialItemsProvider).value ?? [];
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return MaterialItem(item: items[index]);
          },
        );
      },
    );
  }
}

class MaterialItem extends StatelessWidget {
  const MaterialItem({super.key, required this.item});

  final Map<String, dynamic> item;

  String get id => item[Attributes.id];

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          context.pushNamed(Pages.material, pathParameters: {'materialId': id});
        },
        child: HoverBuilder(
          builder: (context, hovered, child) {
            return Stack(
              children: [
                if (hovered)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: MaterialContextMenu(material: item),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      item[Attributes.name],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MaterialContextMenu extends ConsumerWidget {
  const MaterialContextMenu({super.key, required this.material});

  final Map<String, dynamic> material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          final id = material[Attributes.id];
          ref.read(materialServiceProvider).deleteMaterial(id);
        }
      },
      itemBuilder:
          (context) => [PopupMenuItem(value: 'delete', child: Text('Delete'))],
      icon: Icon(Icons.more_vert),
      tooltip: '',
    );
  }
}
