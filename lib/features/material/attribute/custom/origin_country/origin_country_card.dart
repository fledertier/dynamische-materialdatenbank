import 'package:dynamische_materialdatenbank/features/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/custom/origin_country/country.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/custom/origin_country/origin_country_attribute_field.dart';
import 'package:dynamische_materialdatenbank/features/material/attribute/custom/origin_country/world_map.dart';
import 'package:dynamische_materialdatenbank/features/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OriginCountryCard extends ConsumerWidget {
  const OriginCountryCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = ref.watch(
      jsonValueProvider(
        AttributeArgument(
          materialId: materialId,
          attributePath: AttributePath(Attributes.originCountry),
        ),
      ),
    );
    final countries = List<Json>.from(
      values ?? [],
    ).map(Country.fromJson).toList();

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(attributeId: Attributes.originCountry),
      title: OriginCountryAttributeField(
        countries: countries,
        materialId: materialId,
      ),
      child: size > CardSize.small
          ? WorldMap(highlightedCountries: countries)
          : null,
    );
  }
}
