import 'package:dynamische_materialdatenbank/providers/router_provider.dart';
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
      themeMode: isAfterSunset() ? ThemeMode.dark : ThemeMode.light,
    );
  }

  bool isAfterSunset() {
    final sunset = TimeOfDay(hour: 20, minute: 0);
    return TimeOfDay.now().isAfter(sunset);
  }
}
