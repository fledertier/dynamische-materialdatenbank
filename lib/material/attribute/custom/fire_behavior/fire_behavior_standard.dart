import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';

// ignore: constant_identifier_names
enum ReactionToFire { A1, A2, B, C, D, E, F }

enum SmokeProduction { s1, s2, s3 }

enum FlamingDroplets { d0, d1, d2 }

class FireBehaviorStandard {
  final ReactionToFire reactionToFire;
  final SmokeProduction? smokeProduction;
  final FlamingDroplets? flamingDroplets;

  const FireBehaviorStandard({
    required this.reactionToFire,
    this.smokeProduction,
    this.flamingDroplets,
  });

  static final pattern = RegExp(
    r'^(?<reactionToFire>[A-F][1-2]?)(?:-(?<smokeProduction>s[1-3]))?(?:,(?<flamingDroplets>d[0-2]))?$',
  );

  static bool isValid(String value) {
    return pattern.hasMatch(value);
  }

  static FireBehaviorStandard parse(String classification) {
    final match = pattern.firstMatch(classification)!;

    final reactionToFire = ReactionToFire.values.byName(
      match.namedGroup('reactionToFire')!.toUpperCase(),
    );
    final smokeProduction = SmokeProduction.values.maybeByName(
      match.namedGroup('smokeProduction'),
    );
    final flamingDroplets = FlamingDroplets.values.maybeByName(
      match.namedGroup('flamingDroplets'),
    );

    return FireBehaviorStandard(
      reactionToFire: reactionToFire,
      smokeProduction: smokeProduction,
      flamingDroplets: flamingDroplets,
    );
  }
}
