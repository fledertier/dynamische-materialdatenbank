import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'country/country.dart';
import 'country/country_attribute_field.dart';
import 'list/list_attribute_field.dart';
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
    this.onChanged,
  });

  final String attributeId;
  final dynamic value;
  final ValueChanged? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(attributeId)).value;

    if (attribute == null) {
      return const SizedBox();
    }

    switch (attribute.type.id) {
      case AttributeType.text:
        return TextAttributeField(
          attributeId: attributeId,
          text: value as TranslatableText? ?? TranslatableText(),
          onChanged: onChanged,
        );
      case AttributeType.number:
        final number = value as UnitNumber? ?? UnitNumber(value: 0);
        return NumberAttributeField(
          key: ValueKey(number.displayUnit),
          attributeId: attributeId,
          number: number,
          onChanged: onChanged,
        );
      case AttributeType.url:
        return UrlAttributeField(
          attributeId: attributeId,
          url: value as Uri?,
          onChanged: onChanged,
        );
      case AttributeType.country:
        return CountryAttributeField(
          attributeId: attributeId,
          country: value as Country?,
          onChanged: onChanged,
        );
      case AttributeType.list:
        return ListAttributeField(
          attributeId: attributeId,
          list: value as List? ?? [],
          onChanged: onChanged,
        );
      default:
        if (kDebugMode) {
          throw UnimplementedError(
            "$AttributeType ${attribute.type.id} is not implemented in $AttributeField.",
          );
        }
        return Text(value.toString());
    }
  }
}
