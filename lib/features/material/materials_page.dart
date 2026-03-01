import 'package:dynamische_materialdatenbank/core/app/app_scaffold.dart';
import 'package:dynamische_materialdatenbank/shared/widgets/header.dart';
import 'package:dynamische_materialdatenbank/core/app/navigation.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/filter/filters_and_search.dart';
import 'package:dynamische_materialdatenbank/features/material/material_grid.dart';
import 'package:dynamische_materialdatenbank/features/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/features/material/sort.dart';
import 'package:dynamische_materialdatenbank/features/search/material_search.dart';
import 'package:dynamische_materialdatenbank/shared/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class AddMaterialButton extends ConsumerWidget {
  const AddMaterialButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.large(
      child: Icon(Icons.add),
      onPressed: () {
        final id = generateId();
        ref.read(materialProvider(id).notifier).createMaterial();
        context.pushNamed(
          Pages.material,
          pathParameters: {'materialId': id},
          queryParameters: {'edit': 'true'},
        );
      },
    );
  }
}
