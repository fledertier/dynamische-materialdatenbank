import 'package:dynamische_materialdatenbank/header/theme_mode.dart';
import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userProvider, (previous, next) {
      ref.read(routerProvider).refresh();
    });
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      theme: buildTheme(context, Brightness.light),
      darkTheme: buildTheme(context, Brightness.dark),
      themeMode: ref.watch(themeModeProvider),
    );
  }
}
