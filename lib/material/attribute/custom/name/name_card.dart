import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/text_card.dart';
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
