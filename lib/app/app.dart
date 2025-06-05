import 'package:dynamische_materialdatenbank/header/theme_mode.dart';
import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      final userNotifier = ref.read(userProvider.notifier);
      userNotifier.signIn(
        email: 'leon.martin@stud.hs-hannover.de',
        password: 'passwort',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
