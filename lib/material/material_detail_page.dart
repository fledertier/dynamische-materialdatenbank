import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/material/attribute/color/color_service.dart';
import 'package:dynamische_materialdatenbank/material/material_service.dart';
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
import 'attribute/add_attribute_card.dart';
import 'attribute/attribute_card_factory.dart';
import 'attribute/attribute_cards.dart';
import 'attribute/description/description_card.dart';
import 'attribute/name/name_card.dart';
import 'edit_mode_button.dart';
import 'material_provider.dart';

class MaterialDetailPage extends ConsumerStatefulWidget {
  const MaterialDetailPage({super.key, required this.materialId});

  final String materialId;

  @override
  ConsumerState<MaterialDetailPage> createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends ConsumerState<MaterialDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.read(materialStreamProvider(widget.materialId).future).then((material) {
      final name = material[Attributes.name] as String;
      ref.read(colorServiceProvider).createMaterialColor(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncMaterial = ref.watch(materialStreamProvider(widget.materialId));
    final material = asyncMaterial.value ?? {};

    final attributes = ref.watch(attributesStreamProvider).value ?? {};

    final edit = ref.watch(editModeProvider);

    final widgets =
        List<String>.from(
          material[Attributes.widgets] ?? [],
        ).map(AttributeCards.values.maybeByName).nonNulls.toList();

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
                        for (final card in widgets)
                          AttributeCardFactory.create(card, material),
                        // ImageCard(material),
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
                        // SubjectiveImpressionsCard(material),
                        // SubjectiveImpressionsCard.small(material),
                        if (edit)
                          AddAttributeCardButton(
                            material: material,
                            onAdded: (card) {
                              ref.read(materialServiceProvider).updateMaterial({
                                Attributes.id: material[Attributes.id],
                                Attributes.widgets: {
                                  ...?material[Attributes.widgets],
                                  card.name,
                                },
                              });
                            },
                          ),
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
