import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../constants.dart';
import '../filter/filters_and_search.dart';
import '../header/header.dart';
import 'material_grid.dart';
import 'material_service.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  bool showFilters = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: Header(
        onFilter: () {
          setState(() {
            showFilters = true;
          });
        },
      ),
      navigation: Navigation(page: Pages.materials),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MaterialGrid(),
          Positioned(bottom: 16, child: AddMaterialButton()),
        ],
      ),
      sidebar:
          showFilters
              ? FiltersAndSearch(
                onClose: () {
                  setState(() {
                    showFilters = false;
                  });
                },
              )
              : null,
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
