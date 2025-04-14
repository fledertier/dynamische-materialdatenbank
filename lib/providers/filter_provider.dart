import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = NotifierProvider(FilterNotifier.new);

class FilterNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {};

  void updateWith(Map<String, dynamic> options) {
    state = {...state, ...options}..removeWhere((key, value) => value == null);
  }
}
