import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/textarea/textarea_card.dart';
import 'package:flutter/material.dart';

import '../../../../types.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.material,
    required this.size,
  });

  final Json material;
  final CardSize size;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return TextareaCard(
      material: material,
      attribute: Attributes.description,
      size: size,
      textStyle: textTheme.bodyMedium!.copyWith(fontFamily: 'Lexend'),
    );
  }
}
