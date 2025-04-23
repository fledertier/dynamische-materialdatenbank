import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final advancedSearchQueryProvider = ChangeNotifierProvider(
  (ref) => AdvancedSearchQueryNotifier(),
);

class AdvancedSearchQueryNotifier extends ChangeNotifier {
  final query = ConditionGroup(
    type: ConditionGroupType.and,
    nodes: [Condition()],
  );

  void update() {
    notifyListeners();
  }

  void reset() {
    query.type = ConditionGroupType.and;
    query.nodes = [Condition()];
    notifyListeners();
  }
}
