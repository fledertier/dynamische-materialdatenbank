import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_scaffold.dart';
import 'filter/filters.dart';
import 'header/header.dart';
import 'material_grid.dart';
import 'material_service.dart';
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
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              MaterialGrid(),
              Positioned(bottom: 16, child: AddMaterialButton()),
            ],
          ),
        ),
        sidebar: Filters(),
      ),
    );
  }
}

class AddMaterialButton extends ConsumerWidget {
  const AddMaterialButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.large(
      child: Icon(Icons.add),
      onPressed: () {
        ref.read(materialServiceProvider).createMaterial();
      },
    );
  }
}
