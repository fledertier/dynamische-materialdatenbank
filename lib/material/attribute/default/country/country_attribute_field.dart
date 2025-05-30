import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../attributes/attribute_provider.dart';
import '../../../../widgets/enum_field.dart';
import '../../../edit_mode_button.dart';
import 'country.dart';

class CountryAttributeField extends ConsumerWidget {
  const CountryAttributeField({
    super.key,
    required this.attributeId,
    this.country,
    this.onChanged,
  });

  final String attributeId;
  final Country? country;
  final void Function(Country? value)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(attributeId)).value;
    final edit = ref.watch(editModeProvider);

    return EnumField<Country>(
      initialValue: country,
      enabled: edit,
      style: TextTheme.of(context).titleLarge!.copyWith(fontFamily: 'Lexend'),
      decoration: InputDecoration.collapsed(
        hintText: attribute?.name ?? "Country",
      ),
      suggestions: Countries.values,
      findSuggestions: findSuggestions,
      suggestionBuilder: (context, country) {
        return ListTile(
          title: Text(country.name),
          trailing: Text(country.code),
        );
      },
      textExtractor: (country) => country.name,
      onChanged: (country) {
        onChanged?.call(country);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (attribute?.required ?? false) {
            return "Please select a country";
          }
          return null;
        }
        if (!isCountry(value)) {
          return "Please select a valid country";
        }
        return null;
      },
    );
  }

  bool isCountry(String name) {
    return Countries.values.any(
      (country) => country.name.toLowerCase() == name.toLowerCase(),
    );
  }

  List<Country> findSuggestions(String text) {
    final search = text.toLowerCase();

    final matchingName = Countries.values.firstWhereOrNull(
      (country) => country.name.toLowerCase() == search,
    );
    if (matchingName != null) {
      return [];
    }

    final matchingCode = Countries.values.firstWhereOrNull(
      (country) => country.code.toLowerCase() == search,
    );

    final matches =
        Countries.values
            .where((country) => country.name.toLowerCase().contains(search))
            .toList();

    return {if (matchingCode != null) matchingCode, ...matches}.toList();
  }
}
