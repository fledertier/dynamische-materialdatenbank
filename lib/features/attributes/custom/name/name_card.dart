import 'package:dynamische_materialdatenbank/features/attributes/default/text/text_card.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/card_size.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {
  const NameCard({super.key, required this.materialId, required this.size});

  final String materialId;
  final CardSize size;

  @override
  Widget build(BuildContext context) {
    return TextCard(
      columns: 5,
      materialId: materialId,
      attributeId: Attributes.name,
      size: size,
      textStyle: TextTheme.of(context).displaySmall,
    );
  }
}
