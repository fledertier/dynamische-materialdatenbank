import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/origin_country_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/world_map.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/country/country.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
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
    final dings =
        ref.watch(
              valueProvider(
                AttributeArgument(
                  materialId: materialId,
                  attributeId: Attributes.originCountry,
                ),
              ),
            )
            as List?;
    final countries = [Country.fromCode('se')];

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(attributeId: Attributes.originCountry),
      title: OriginCountryAttributeField(
        countries: countries,
        materialId: materialId,
      ),
      child:
          size > CardSize.small
              ? WorldMap(
                key: ValueKey(
                  countries.map((country) => country.code).join(','),
                ),
                highlightedCountries: countries,
              )
              : null,
    );
  }
}
