import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../types.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../cards.dart';

class NumberCard extends ConsumerWidget {
  const NumberCard({
    super.key,
    required this.material,
    required this.attribute,
    required this.size,
  });

  final Json material;
  final String attribute;
  final CardSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = ref.watch(attributeProvider(attribute));
    final value = material[attribute] ?? 0;

    return AttributeCard(
      label: AttributeLabel(
        label: metadata?.name,
        value: value.toStringAsFixed(1),
        onChanged: (value) {
          ref.read(materialServiceProvider).updateMaterial(material, {
            attribute: double.tryParse(value) ?? 0,
          });
        },
      ),
    );
  }
}
