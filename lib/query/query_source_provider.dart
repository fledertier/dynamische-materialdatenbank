import 'package:flutter_riverpod/flutter_riverpod.dart';

enum QuerySource { searchAndFilter, advancedSearch }

final querySourceProvider = StateProvider((ref) {
  return QuerySource.searchAndFilter;
});
