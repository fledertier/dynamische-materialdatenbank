import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/material/attribute/color/color_service.dart';
import 'package:dynamische_materialdatenbank/search/material_search.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_hero/local_hero.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../attributes/attribute_provider.dart';
import '../constants.dart';
import '../header/header.dart';
import '../widgets/drag_and_drop/add_section_button.dart';
import '../widgets/drag_and_drop/draggable_section.dart';
import '../widgets/drag_and_drop/local_hero_overlay.dart';
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

    final cardSections = CardSections.fromJson(
      material[Attributes.cardSections] ?? {},
    );

    return AppScaffold(
      header: Header(search: MaterialSearch(), actions: [EditModeButton()]),
      navigation: Navigation(page: Pages.materials),
      body:
          asyncMaterial.isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widthByColumns(5)),
                  child: LocalHeroScope(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    createRectTween: (begin, end) {
                      return RectTween(begin: begin, end: end);
                    },
                    child: LocalHeroOverlay(
                      clip: Clip.none,
                      child: ProviderScope(
                        overrides: [
                          sectionsProvider.overrideWith(
                            (ref) => cardSections.primary,
                          ),
                        ],
                        child: Consumer(
                          builder: (context, ref, child) {
                            final sections = ref.watch(sectionsProvider);

                            return ListView.builder(
                              itemCount: sections.length + (edit ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == sections.length) {
                                  return AddSectionButton();
                                }
                                return DraggableSection(
                                  sectionIndex: index,
                                  materialId: material[Attributes.id],
                                  itemBuilder: (context, item) {
                                    return CardFactory.getOrCreate(
                                      item,
                                      widget.materialId,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
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
