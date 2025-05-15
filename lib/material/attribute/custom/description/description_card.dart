import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:flutter/material.dart';

import '../../default/textarea/textarea_card.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.materialId,
    required this.size,
  });

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return TextareaCard(
      materialId: materialId,
      attributeId: Attributes.description,
      size: size,
      textStyle: textTheme.bodyMedium!.copyWith(fontFamily: 'Lexend'),
    );
  }
}
