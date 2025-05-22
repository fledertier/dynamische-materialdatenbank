import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants.dart';
import '../../../../widgets/tags_field/selectable_tag.dart';
import '../../../../widgets/tags_field/tags_field.dart';
import '../../../edit_mode_button.dart';
import '../../../material_provider.dart';
import '../../cards.dart';
import 'countries.dart';

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
    final edit = ref.watch(editModeProvider);

    final value = ref.watch(
      materialAttributeValueProvider(
        AttributeArgument(
          materialId: materialId,
          attributeId: Attributes.originCountry,
        ),
      ),
    );

    final countries = parseCountries(value ?? ['se']);

    // todo: extract country_attribute_field into lib/material/attribute/default/country
    late final field = SizedBox(
      width: 300,
      child: TagsField<Country>(
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
          ref.read(materialProvider(materialId).notifier).updateMaterial({
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
              : Text(
                countries.map((country) => country.name).join(', '),
                style: TextTheme.of(context).titleLarge,
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

  List<Country> parseCountries(dynamic value) {
    return List<String>.from(value).map(Country.fromCode).toList();
  }
}
