import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/materials_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributeTable extends ConsumerWidget {
  const AttributeTable({super.key, required this.attribute});

  final String attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMaterials = ref.watch(
      materialsProvider(AttributesArgument({Attributes.name, attribute})),
    );

    if (asyncMaterials.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final materials = (asyncMaterials.value ?? []).where(
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
                  child: Text(
                    header,
                    style: TextTheme.of(context).labelMedium?.copyWith(
                      color: ColorScheme.of(context).onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          for (final material in materials)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    TranslatableText.fromJson(material[Attributes.name]).value,
                  ),
                ),
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
