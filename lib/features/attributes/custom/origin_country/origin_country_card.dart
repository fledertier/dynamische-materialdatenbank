import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/widgets/attribute_label.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/origin_country/country.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/origin_country/origin_country_attribute_field.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/origin_country/world_map.dart';
import 'package:dynamische_materialdatenbank/features/material/providers/material_provider.dart';
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
    final argument = AttributeArgument(
      materialId: materialId,
      attributePath: AttributePath(Attributes.originCountry),
    );
    final values = ref.watch(jsonValueProvider(argument));
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
