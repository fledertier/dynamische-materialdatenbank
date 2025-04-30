import 'package:dynamische_materialdatenbank/material/attribute/fire_behavior/scale.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../types.dart';
import 'fire_behavior_standard.dart';

class FireBehaviorStandardVisualization extends StatelessWidget {
  const FireBehaviorStandardVisualization(this.value, {super.key});

  final FireBehaviorStandard value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    return DefaultTextStyle.merge(
      style: textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Scale(
                value: value.reactionToFire,
                values: ReactionToFire.values,
                icon: Icon(Symbols.local_fire_department),
                spacing: -4,
              ),
              Text(labelForReactionToFire(context, value.reactionToFire)),
            ],
          ),
          Dings(
            spacing: 32,
            runSpacing: 16,
            children: [
              if (value.smokeProduction != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Scale(
                      value: value.smokeProduction!,
                      values: SmokeProduction.values,
                      icon: Icon(Symbols.cloud),
                      spacing: 8,
                    ),
                    Text(
                      labelForSmokeProduction(context, value.smokeProduction!),
                    ),
                  ],
                ),
              if (value.flamingDroplets != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Scale(
                      value: value.flamingDroplets!,
                      values: FlamingDroplets.values,
                      icon: Icon(Symbols.water_drop),
                      spacing: -4,
                    ),
                    Text(
                      labelForFlamingDroplets(context, value.flamingDroplets!),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  String labelForReactionToFire(BuildContext context, ReactionToFire value) {
    return switch (value) {
      ReactionToFire.A1 => 'nicht brennbar ohne brennbare Bestandteile',
      ReactionToFire.A2 => 'nicht brennbar mit brennbaren Bestandteilen',
      ReactionToFire.B => 'schwer entflammbar',
      ReactionToFire.C => 'schwer entflammbar',
      ReactionToFire.D => 'normal entflammbar',
      ReactionToFire.E => 'normal entflammbar',
      ReactionToFire.F => 'leicht entflammbar',
    };
  }

  String labelForSmokeProduction(BuildContext context, SmokeProduction value) {
    return switch (value) {
      SmokeProduction.s1 => 'keine / kaum Rauchentwicklung',
      SmokeProduction.s2 => 'begrenzte Rauchentwicklung',
      SmokeProduction.s3 => 'unbeschränkte Rauchentwicklung',
    };
  }

  String labelForFlamingDroplets(BuildContext context, FlamingDroplets value) {
    return switch (value) {
      FlamingDroplets.d0 => 'kein Abtropfen / Abfallen',
      FlamingDroplets.d1 => 'begrenztes Abtropfen / Abfallen',
      FlamingDroplets.d2 => 'starkes Abtropfen / Abfallen',
    };
  }
}
