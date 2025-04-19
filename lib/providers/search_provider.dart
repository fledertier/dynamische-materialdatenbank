import 'package:dynamische_materialdatenbank/advanced_search/advanced_search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = NotifierProvider(SearchNotifier.new);

class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  set query(String query) {
    state = query;
    ref.read(queryProvider.notifier).searchQuery = query;
  }
}
