import 'package:dynamische_materialdatenbank/features/attributes/default/text/text_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/cards.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:flutter/material.dart';

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
    return TextCard(
      materialId: materialId,
      attributeId: Attributes.description,
      size: size,
      textStyle: TextTheme.of(context).bodyMedium,
    );
  }
}
