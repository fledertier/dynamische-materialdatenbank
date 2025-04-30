import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/u_value_card.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../constants.dart';
import '../header/header.dart';
import '../widgets/labeled.dart';
import 'attribute/light_absorption_card.dart';
import 'attribute/light_reflection_card.dart';
import 'attribute/light_transmission_card.dart';
import 'attribute/origin_country_card.dart';
import 'attribute/w_value_card.dart';
import 'edit_mode_button.dart';

class MaterialDetailPage extends ConsumerWidget {
  const MaterialDetailPage({super.key, required this.materialId});

  final String materialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMaterial = ref.watch(materialStreamProvider(materialId));
    final material = asyncMaterial.value ?? {};

    final attributes = ref.watch(attributesStreamProvider).value ?? {};

    return AppScaffold(
      header: Header(actions: [EditModeButton()]),
      navigation: Navigation(page: Pages.materials),
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child:
              asyncMaterial.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        LightReflectionCard(material),
                        LightAbsorptionCard(material),
                        LightTransmissionCard(material),
                        UValueCard(material),
                        WValueCard(material),
                        OriginCountryCard(material),
                      ],
                    ),
                  ),
        ),
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
