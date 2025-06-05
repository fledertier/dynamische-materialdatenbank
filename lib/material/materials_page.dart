import 'package:dynamische_materialdatenbank/app/app_scaffold.dart';
import 'package:dynamische_materialdatenbank/app/header.dart';
import 'package:dynamische_materialdatenbank/app/navigation.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/filter/filters_and_search.dart';
import 'package:dynamische_materialdatenbank/header/sort.dart';
import 'package:dynamische_materialdatenbank/material/material_grid.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/search/material_search.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  bool showFilters = true;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: Header(
        center: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialSearch(
              onFilter: () {
                setState(() {
                  showFilters = !showFilters;
                });
              },
            ),
            SizedBox(width: 24),
            SortButton(),
          ],
        ),
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
        ref.read(materialProvider(generateId()).notifier).createMaterial();
      },
    );
  }
}
