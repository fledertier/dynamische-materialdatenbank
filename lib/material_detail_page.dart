import 'package:dynamische_materialdatenbank/providers/material_provider.dart';
import 'package:dynamische_materialdatenbank/providers/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_scaffold.dart';
import 'header/header.dart';
import 'navigation.dart';

class MaterialDetailPage extends ConsumerWidget {
  const MaterialDetailPage({super.key, required this.materialId});

  final String materialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMaterial = ref.watch(materialStreamProvider(materialId));
    final material = asyncMaterial.value ?? {};

    return AppScaffold(
      header: Header(),
      navigation: Navigation(page: Pages.material),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: asyncMaterial.isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : null,
      ),
      sidebar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: asyncMaterial.isLoading ? null : SizedBox(
          width: 300,
          child: ListView(
            children: [
              for (final attribute in material.keys)
                ListTile(
                  title: Text(attribute),
                  subtitle: Text(material[attribute].toString()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
