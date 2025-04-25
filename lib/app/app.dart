import 'package:dynamische_materialdatenbank/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.read(routerProvider),
      debugShowCheckedModeBanner: false,
      theme: buildTheme(context, Brightness.light),
      darkTheme: buildTheme(context, Brightness.dark),
      themeMode: isDarkOutside() ? ThemeMode.dark : ThemeMode.light,
    );
  }

  bool isDarkOutside() {
    final now = TimeOfDay.now();
    final sunset = TimeOfDay(hour: 19, minute: 00);
    final sunrise = TimeOfDay(hour: 7, minute: 00);
    return now.isAfter(sunset) || now.isBefore(sunrise);
  }
}
