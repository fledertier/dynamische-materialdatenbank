import 'package:dynamische_materialdatenbank/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../header/theme_mode.dart';
import 'theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      routerConfig: ref.read(routerProvider),
      debugShowCheckedModeBanner: false,
      theme: buildTheme(context, Brightness.light),
      darkTheme: buildTheme(context, Brightness.dark),
      themeMode: themeMode,
    );
  }
}
