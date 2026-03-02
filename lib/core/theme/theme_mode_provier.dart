import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return isDarkOutside() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDarkOutside() {
    final now = TimeOfDay.now();
    final sunset = TimeOfDay(hour: 20, minute: 40);
    final sunrise = TimeOfDay(hour: 6, minute: 00);
    return now.isAfter(sunset) || now.isBefore(sunrise);
  }

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
