import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = StateProvider((ref) => '');

final searchControllerProvider = Provider((ref) {
  final controller = SearchController();
  ref.onDispose(controller.dispose);
  return controller;
});
