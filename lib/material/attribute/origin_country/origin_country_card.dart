import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/origin_country/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../cards.dart';
import '../../edit_mode_button.dart';
import 'countries.dart';

class OriginCountryCard extends ConsumerWidget {
  const OriginCountryCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(Attributes.originCountry));
    final countries = parseCountries(
      material[Attributes.originCountry] ?? ['SE'],
    );

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(
        label: attribute?.name,
        value: countries.map((country) => country.name).join(', '),
      ),
      child: WorldMap(highlightedCountries: countries),
    );
  }

  List<Country> parseCountries(dynamic value) {
    return List<String>.from(value).map(Country.fromIso).toList();
  }
}
