import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'country/country.dart';
import 'country/country_attribute_field.dart';
import 'number/number_attribute_field.dart';
import 'number/unit_number.dart';
import 'text/text_attribute_field.dart';
import 'text/translatable_text.dart';
import 'url/url_attribute_field.dart';

class AttributeField extends ConsumerWidget {
  const AttributeField({
    super.key,
    required this.attributeId,
    required this.value,
    this.onValue,
    this.onJson,
  });

  final String attributeId;
  final dynamic value;
  final ValueChanged<dynamic>? onValue;
  final ValueChanged<dynamic>? onJson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(attributeId)).value;

    if (attribute == null) {
      return const SizedBox();
    }

    // todo: add list
    switch (attribute.type.id) {
      case AttributeType.text:
        return TextAttributeField(
          attributeId: attributeId,
          text: value as TranslatableText? ?? TranslatableText(),
          onChanged: (text) {
            onValue?.call(text);
            onJson?.call(text.toJson());
          },
        );
      case AttributeType.number:
        final number = value as UnitNumber? ?? UnitNumber(value: 0);
        return NumberAttributeField(
          key: ValueKey(number.displayUnit),
          attributeId: attributeId,
          number: number,
          onChanged: (number) {
            onValue?.call(number);
            onJson?.call(number.toJson());
          },
        );
      case AttributeType.url:
        return UrlAttributeField(
          attributeId: attributeId,
          url: value as Uri?,
          onChanged: (url) {
            onValue?.call(url);
            onJson?.call(url?.toJson());
          },
        );
      case AttributeType.country:
        final country = value as Country?;
        return CountryAttributeField(
          attributeId: attributeId,
          country: country,
          onChanged: (country) {
            onValue?.call(country);
            onJson?.call(country?.toJson());
          },
        );
      default:
        if (kDebugMode) {
          throw UnimplementedError(
            "Attribute type ${attribute.type.id} is not implemented in AttributeField.",
          );
        }
        return Text(value.toString());
    }
  }
}
