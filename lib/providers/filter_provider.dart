import 'package:dynamische_materialdatenbank/filter/filter_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = NotifierProvider(FilterNotifier.new);

class FilterNotifier extends Notifier<FilterOptions> {
  @override
  FilterOptions build() => FilterOptions();

  set options(FilterOptions options) {
    state = options;
  }
}
