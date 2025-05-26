import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/enum_field.dart';
import 'country.dart';

class CountryAttributeField extends StatelessWidget {
  const CountryAttributeField({
    super.key,
    this.country,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
  });

  final Country? country;
  final void Function(Country? value) onChanged;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return EnumField<Country>(
      enabled: enabled,
      decoration: InputDecoration(
        hintText: 'Country',
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: EdgeInsets.zero,
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
        onChanged(country);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (required) {
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
