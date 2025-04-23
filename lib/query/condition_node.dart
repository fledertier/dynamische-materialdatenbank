import '../types.dart';

abstract class ConditionNode {
  const ConditionNode();

  bool get isValid;

  Set<String> get attributes;

  bool matches(Material material);
}
