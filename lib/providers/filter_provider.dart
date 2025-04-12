import 'package:dynamische_materialdatenbank/filter/filter_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = NotifierProvider(FilterNotifier.new);

class FilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() => FilterState();

  @override
  set state(FilterState filterState) {
    super.state = filterState;
  }
}
