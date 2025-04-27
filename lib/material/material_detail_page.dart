import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../constants.dart';
import '../header/header.dart';
import '../widgets/labeled.dart';
import 'attribute/light_transmission_card.dart';

class MaterialDetailPage extends ConsumerWidget {
  const MaterialDetailPage({super.key, required this.materialId});

  final String materialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMaterial = ref.watch(materialStreamProvider(materialId));
    final material = asyncMaterial.value ?? {};

    final attributes = ref.watch(attributesStreamProvider).value ?? {};

    return AppScaffold(
      header: Header(),
      navigation: Navigation(page: Pages.materials),
      body: Container(
        decoration: BoxDecoration(
          color: ColorScheme.of(context).surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            asyncMaterial.isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(child: LightTransmissionCard(value: 0.63)),
      ),
      sidebar: Container(
        decoration: BoxDecoration(
          color: ColorScheme.of(context).surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            asyncMaterial.isLoading
                ? null
                : SizedBox(
                  width: 300,
                  child: ListView(
                    children: [
                      for (final attribute in material.keys)
                        Labeled(
                          label: Text(attributes[attribute]?.name ?? attribute),
                          child: Text(material[attribute].toString()),
                        ),
                    ],
                  ),
                ),
      ),
    );
  }
}
