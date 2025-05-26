import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/selectable_tag.dart';
import 'package:dynamische_materialdatenbank/widgets/tags_field/tags_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../default/country/country.dart';

class OriginCountryAttributeField extends ConsumerWidget {
  const OriginCountryAttributeField({
    super.key,
    required this.countries,
    required this.materialId,
  });

  final List<Country> countries;
  final String materialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editModeProvider);

    if (!edit) {
      return Text(
        countries.map((country) => country.name).join(', '),
        style: TextTheme.of(context).titleLarge,
      );
    }

    return TagsField<Country>(
      decoration: InputDecoration(
        hintText: 'Countries',
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
    );
  }
}
