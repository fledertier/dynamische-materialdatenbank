import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/material/attribute/subjective_impressions/subjective_impressions_card.dart';
import 'package:dynamische_materialdatenbank/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../attributes/attribute_provider.dart';
import '../constants.dart';
import '../header/header.dart';
import '../widgets/labeled.dart';
import '../widgets/sheet.dart';
import 'attribute/description/description_card.dart';
import 'attribute/image/image_card.dart';
import 'attribute/name/name_card.dart';
import 'edit_mode_button.dart';
import 'material_provider.dart';

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
      body: SingleChildScrollView(
        child:
            asyncMaterial.isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: widthByColumns(5)),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        NameCard(material),
                        DescriptionCard(material),
                        ImageCard(material),
                        // LightReflectionCard(material),
                        // LightAbsorptionCard(material),
                        // LightTransmissionCard(material),
                        // UValueCard(material),
                        // WValueCard(material),
                        // OriginCountryCard(material),
                        // CompositionCard(material),
                        // CompositionCard.small(material),
                        // FireBehaviorStandardCard(material),
                        // ArealDensityCard(material),
                        // DensityCard(material),
                        // ComponentsCard(material),
                        // ComponentsCard.small(material),
                        SubjectiveImpressionsCard(material),
                      ],
                    ),
                  ),
                ),
      ),
      sidebar:
          asyncMaterial.isLoading
              ? null
              : Sheet(
                width: 300,
                child: ListView(
                  children: [
                    for (final attribute in material.keys.sorted())
                      Labeled(
                        label: Text(attributes[attribute]?.name ?? attribute),
                        child: Text(material[attribute].toString()),
                      ),
                  ],
                ),
              ),
    );
  }
}
