import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = NotifierProvider(SearchNotifier.new);

// todo: use state provider
class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  set search(String query) {
    state = query;
  }
}
