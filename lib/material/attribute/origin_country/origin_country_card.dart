import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/origin_country/world_map.dart';
import 'package:flutter/material.dart';

import '../../../types.dart';

class OriginCountryCard extends StatelessWidget {
  const OriginCountryCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context) {
    return AttributeCard(
      columns: 2,
      label: AttributeLabel(label: 'Origin country', value: 'Sweden'),
      child: WorldMap(highlightedCountries: ['se']),
    );
  }
}
