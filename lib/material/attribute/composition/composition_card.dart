import 'package:dynamische_materialdatenbank/material/attribute/composition/material_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attributes/attribute_provider.dart';
import '../../../constants.dart';
import '../../../types.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';

class CompositionCard extends ConsumerWidget {
  const CompositionCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attribute = ref.watch(attributeProvider(Attributes.composition));
    final value =
        material[Attributes.composition] ??
        {
          MaterialCategory.minerals: 58,
          MaterialCategory.woods: 40,
          MaterialCategory.plastics: 2,
        };

    return AttributeCard(
      columns: 4,
      label: AttributeLabel(label: attribute?.name),
      child: Row(
        spacing: 8,
        children: [
          for (final entry in value.entries)
            CompositionElement(category: entry.key, share: entry.value),
        ],
      ),
    );
  }
}

class CompositionElement extends StatelessWidget {
  const CompositionElement({
    super.key,
    required this.category,
    required this.share,
  });

  final MaterialCategory category;
  final double share;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Flexible(
      flex: share.round(),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: category.color,
          shape: StadiumBorder(),
        ),
        child: Text(
          category.name,
          style: textTheme.bodyLarge!.copyWith(
            fontFamily: 'Lexend',
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
