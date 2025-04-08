import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/material_provider.dart';
import 'services/material_service.dart';

class MaterialGrid extends StatelessWidget {
  const MaterialGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final items = ref.watch(materialItemsStreamProvider).value ?? [];
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

class MaterialItem extends StatelessWidget {
  const MaterialItem({super.key, required this.item});

  final Map<String, dynamic> item;

  String get id => item["id"];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.pushNamed('details', pathParameters: {'materialId': id});
        },
        child: Stack(
          children: [
            Positioned(
              top: 4,
              right: 4,
              child: Consumer(
                builder: (context, ref, child) {
                  return PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        final id = item["id"];
                        ref.read(materialServiceProvider).deleteMaterial(id);
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => [
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                    icon: Icon(Icons.more_vert),
                    tooltip: '',
                  );
                },
              ),
            ),
            Positioned(bottom: 12, left: 12, child: Text(item["name"])),
          ],
        ),
      ),
    );
  }
}
