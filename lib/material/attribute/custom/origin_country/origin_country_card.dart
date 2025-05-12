import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/world_map.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/text_attribute_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';
import '../../../../types.dart';
import '../../../../widgets/tags_field/selectable_tag.dart';
import '../../../../widgets/tags_field/tags_field.dart';
import '../../cards.dart';
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
    final countries = parseCountries(
      material[Attributes.originCountry] ?? ['se'],
    );

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(attribute: Attributes.originCountry),
      title: TextAttributeField(
        attribute: Attributes.originCountry,
        value: countries.map((country) => country.name).join(', '),
      ),
      child:
          size > CardSize.small
              ? WorldMap(highlightedCountries: countries)
              : null,
    );

    SizedBox(
      width: 300,
      child: TagsField<String>(
        decoration: InputDecoration(
          hintText: "Tags",
          border: const OutlineInputBorder(),
        ),
        suggestions: ["Schweden", "Deutschland", "Frankreich"],
        suggestValueBuilder: (context, value) {
          return ListTile(title: Text(value));
        },
        tagBuilder: (String value, bool isSelected) {
          return SelectableTag(
            label: Text(value),
            backgroundColor: Color(0xffe5f6fe),
            selected: isSelected,
          );
        },
        textExtractor: (value) => value,
      ),
    );
  }

  List<Country> parseCountries(dynamic value) {
    return List<String>.from(value).map(Country.fromIso).toList();
  }
}
