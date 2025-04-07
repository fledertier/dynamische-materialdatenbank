import 'package:flutter/material.dart';

import 'app_scaffold.dart';
import 'filters.dart';
import 'header.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(context),
      home: AppScaffold(
        header: Header(),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Text('Hello World!')),
        ),
        sidebar: Filters(),
      ),
    );
  }
}
