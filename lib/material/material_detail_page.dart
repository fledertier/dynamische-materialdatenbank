import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/material/attribute/color/color_service.dart';
import 'package:dynamische_materialdatenbank/search/material_search.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../attributes/attribute_provider.dart';
import '../constants.dart';
import '../header/header.dart';
import '../types.dart';
import '../widgets/drag_and_drop/reorderable_wrap.dart';
import '../widgets/labeled.dart';
import '../widgets/sheet.dart';
import 'attribute/cards.dart';
import 'edit_mode_button.dart';
import 'material_provider.dart';

class MaterialDetailPage extends ConsumerStatefulWidget {
  const MaterialDetailPage({super.key, required this.materialId});

  final String materialId;

  @override
  ConsumerState<MaterialDetailPage> createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends ConsumerState<MaterialDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.read(materialStreamProvider(widget.materialId).future).then((material) {
      final name = material[Attributes.name] as String;
      ref.read(colorServiceProvider).createMaterialColor(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncMaterial = ref.watch(materialStreamProvider(widget.materialId));
    final material = asyncMaterial.value ?? {};

    final attributes = ref.watch(attributesProvider).value ?? {};

    final edit = ref.watch(editModeProvider);

    final cards =
        List<Json>.from(
          material[Attributes.cards] ?? [],
        ).map(CardData.fromJson).toList();

    return AppScaffold(
      header: Header(search: MaterialSearch(), actions: [EditModeButton()]),
      navigation: Navigation(page: Pages.materials),
      body: SingleChildScrollView(
        child:
            asyncMaterial.isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: widthByColumns(5)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 32,
                      children: [
                        ReorderableWrap(
                          cards: cards.take(3).toList(),
                          materialId: material[Attributes.id],
                        ),
                        ReorderableWrap(
                          cards: cards.skip(3).toList(),
                          materialId: material[Attributes.id],
                        ),
                      ],
                    ),
                  ),
                ),
      ),
      sidebar:
          asyncMaterial.isLoading
              ? null
              : Sheet(
                width: 300,
                child: ListView(
                  children: [
                    for (final attribute in material.keys.sorted())
                      Labeled(
                        label: Text(attributes[attribute]?.name ?? attribute),
                        child: Text(material[attribute].toString()),
                      ),
                  ],
                ),
              ),
    );
  }
}
