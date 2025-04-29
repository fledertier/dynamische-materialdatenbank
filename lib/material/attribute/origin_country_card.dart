import 'package:dynamische_materialdatenbank/material/attribute/world_map.dart';
import 'package:flutter/material.dart';

import '../../types.dart';

class OriginCountryCard extends StatelessWidget {
  const OriginCountryCard(this.material, {super.key});

  final Json material;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text('Origin country', style: TextTheme.of(context).labelMedium),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Text(
                    "Sweden",
                    style: TextTheme.of(
                      context,
                    ).titleLarge?.copyWith(fontFamily: 'Lexend'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 126 * 2,
            child: WorldMap(highlightedCountries: ["se"]),
          ),
        ],
      ),
    );
  }
}
