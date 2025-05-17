import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'attribute_provider.dart';

class AttributeTable extends ConsumerWidget {
  const AttributeTable({super.key, required this.attribute});

  final String attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMaterials = ref.watch(
      attributesValuesProvider(
        AttributesArgument({Attributes.name, attribute}),
      ),
    );

    if (asyncMaterials.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final materials = (asyncMaterials.value?.values ?? []).where(
      (material) => material[attribute] != null,
    );

    if (materials.isEmpty) {
      return Center(
        child: Text(
          'No values for this attribute',
          style: TextStyle(color: ColorScheme.of(context).onSurfaceVariant),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Table(
        children: [
          TableRow(
            children: [
              for (final header in ['Material', 'Value'])
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(header, style: TextTheme.of(context).labelMedium),
                ),
            ],
          ),
          for (final material in materials)
            TableRow(
              children: [
                for (final attribute in [Attributes.name, attribute])
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(material[attribute].toString()),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
