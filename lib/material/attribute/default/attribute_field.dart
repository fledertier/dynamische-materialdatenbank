import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/list/list_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/number_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/object/object_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/text_attribute_field.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributeField extends ConsumerWidget {
  const AttributeField({
    super.key,
    required this.attributePath,
    required this.value,
    this.isRoot = false,
    this.onChanged,
    this.onSave,
  });

  final AttributePath attributePath;
  final dynamic value;
  final bool isRoot;
  final ValueChanged? onChanged;
  final ValueChanged? onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(attributePath)).value;

    if (attribute == null) {
      return const SizedBox();
    }

    switch (attribute.type.id) {
      case AttributeType.text:
        return TextAttributeField(
          attributePath: attributePath,
          text: value as TranslatableText? ?? TranslatableText(),
          onChanged: onChanged,
        );
      case AttributeType.number:
        final number = value as UnitNumber? ?? UnitNumber(value: 0);
        return NumberAttributeField(
          key: ValueKey(number.displayUnit),
          attributePath: attributePath,
          number: number,
          onChanged: onChanged,
        );
      case AttributeType.list:
        return ListAttributeField(
          attributePath: attributePath,
          list: value as List? ?? [],
          onChanged: onChanged,
        );
      case AttributeType.object:
        return ObjectAttributeField(
          attributePath: attributePath,
          object: value as Json?,
          isRoot: isRoot,
          onChanged: onChanged,
          onSave: onSave,
        );
      default:
        if (kDebugMode) {
          throw UnimplementedError(
            '$AttributeType ${attribute.type.id} is not implemented in $AttributeField.',
          );
        }
        return Text(value.toString());
    }
  }
}
