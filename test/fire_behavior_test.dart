import 'package:dynamische_materialdatenbank/material/attribute/custom/fire_behavior/fire_behavior_standard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FireBehaviorStandard parse', () {
    test('parse B-s2,d1', () {
      final value = 'B-s2,d1';
      final fireBehavior = FireBehaviorStandard.parse(value);

      expect(fireBehavior.reactionToFire, ReactionToFire.B);
      expect(fireBehavior.smokeProduction, SmokeProduction.s2);
      expect(fireBehavior.flamingDroplets, FlamingDroplets.d1);
    });

    test('parse A1-s1', () {
      final value = 'A1-s1';
      final fireBehavior = FireBehaviorStandard.parse(value);

      expect(fireBehavior.reactionToFire, ReactionToFire.A1);
      expect(fireBehavior.smokeProduction, SmokeProduction.s1);
      expect(fireBehavior.flamingDroplets, null);
    });

    test('isValid', () {
      expect(FireBehaviorStandard.isValid('B-s2,d1'), true);
      expect(FireBehaviorStandard.isValid('D,d2'), true);
      expect(FireBehaviorStandard.isValid('A1-s3,d0'), true);
      expect(FireBehaviorStandard.isValid('C-s1'), true);
      expect(FireBehaviorStandard.isValid('invalid'), false);
    });
  });
}
