import 'package:dynamische_materialdatenbank/query/condition.dart';
import 'package:dynamische_materialdatenbank/query/condition_group.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final advancedSearchQueryProvider = ChangeNotifierProvider(
  (ref) => AdvancedSearchQueryNotifier(),
);

class AdvancedSearchQueryNotifier extends ChangeNotifier {
  final query = ConditionGroup.and([Condition()]);

  set query(ConditionGroup query) {
    this.query.nodes = query.nodes;
    this.query.type = query.type;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void reset() {
    query.type = ConditionGroupType.and;
    query.nodes = [Condition()];
    notifyListeners();
  }
}
