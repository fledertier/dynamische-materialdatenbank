import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';
import 'providers/material_provider.dart';
import 'services/material_service.dart';

class MaterialGrid extends StatelessWidget {
  const MaterialGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final items =
            ref.watch(filteredMaterialItemsStreamProvider).value ?? [];
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return MaterialItem(item: items[index]);
          },
        );
      },
    );
  }
}

class MaterialItem extends StatefulWidget {
  const MaterialItem({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  State<MaterialItem> createState() => _MaterialItemState();
}

class _MaterialItemState extends State<MaterialItem> {
  final hovered = ValueNotifier(false);

  String get id => widget.item[Attributes.id];

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: MouseRegion(
        onEnter: (event) => hovered.value = true,
        onExit: (event) => hovered.value = false,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            context.pushNamed(
              Pages.material,
              pathParameters: {'materialId': id},
            );
          },
          child: Stack(
            children: [
              Positioned(
                top: 4,
                right: 4,
                child: ListenableBuilder(
                  listenable: hovered,
                  builder: (context, child) {
                    return Offstage(
                      offstage: !hovered.value,
                      child: MaterialContextMenu(material: widget.item),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.item[Attributes.name],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
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
