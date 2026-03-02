import 'package:dynamische_materialdatenbank/features/material/widgets/add_material_button.dart';
import 'package:dynamische_materialdatenbank/features/sort/widgets/sort_buttons.dart';
import 'package:dynamische_materialdatenbank/shared/widgets/app_scaffold.dart';
import 'package:dynamische_materialdatenbank/shared/widgets/header.dart';
import 'package:dynamische_materialdatenbank/core/app/navigation.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/filter/widgets/filters_and_search.dart';
import 'package:dynamische_materialdatenbank/features/material/widgets/material_grid.dart';
import 'package:dynamische_materialdatenbank/features/search/widgets/material_search.dart';
import 'package:flutter/material.dart';

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
            Flexible(
              child: MaterialSearch(
                onFilter: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
              ),
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
      sidebar: showFilters
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
