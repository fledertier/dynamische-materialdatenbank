import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeButton extends ConsumerWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return IconButton(
      icon: Icon(
        themeMode == ThemeMode.light
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
      ),
      onPressed: () {
        ref.read(themeModeProvider.notifier).toggle();
      },
    );
  }
}

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
