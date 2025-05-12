import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/world_map.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/text_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/material_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';
import '../../../../types.dart';
import '../../../../widgets/tags_field/selectable_tag.dart';
import '../../../../widgets/tags_field/tags_field.dart';
import '../../../edit_mode_button.dart';
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

  // final controller = TagsController<Country>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);

    final countries = parseCountries(
      material[Attributes.originCountry] ?? ['se'],
    );

    late final field = SizedBox(
      width: 300,
      child: TagsField<Country>(
        // controller: controller,
        decoration: InputDecoration(
          hintText: "Countries",
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.zero,
        ),
        suggestions: Countries.values,
        suggestValueBuilder: (context, country) {
          return ListTile(title: Text(country.name));
        },
        tagBuilder: (Country country, bool isSelected) {
          return SelectableTag(
            label: Text(country.name),
            backgroundColor: ColorScheme.of(context).surfaceContainer,
            selected: isSelected,
          );
        },
        hideSuggestionsOnSelect: true,
        textExtractor: (country) => country.name,
        initialTags: countries,
        onChanged: (countries) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            Attributes.originCountry:
                countries.map((country) => country.code).toList(),
          });
        },
      ),
    );

    return AttributeCard(
      columns: 2,
      label: AttributeLabel(attribute: Attributes.originCountry),
      title:
          edit
              ? field
              : TextAttributeField(
                attribute: Attributes.originCountry,
                value: countries.map((country) => country.name).join(', '),
              ),
      child:
          size > CardSize.small
              ? WorldMap(highlightedCountries: countries)
              : null,
    );
  }

  List<Country> parseCountries(dynamic value) {
    return List<String>.from(value).map(Country.fromCode).toList();
  }
}
