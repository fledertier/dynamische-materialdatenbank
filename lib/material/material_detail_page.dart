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
import '../widgets/drag_and_drop/add_section_button.dart';
import '../widgets/drag_and_drop/draggable_section.dart';
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

    return ProviderScope(
      overrides: [
        sectionsProvider(
          SectionCategory.primary,
        ).overrideWith((ref) => cardSections.primary),
        sectionsProvider(
          SectionCategory.secondary,
        ).overrideWith((ref) => cardSections.secondary),
      ],
      child: AppScaffold(
        header: Header(search: MaterialSearch(), actions: [EditModeButton()]),
        navigation: Navigation(page: Pages.materials),
        body:
            asyncMaterial.isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: widthByColumns(5)),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final sections = ref.watch(
                          sectionsProvider(SectionCategory.primary),
                        );

                        return ListView.builder(
                          itemCount: sections.length + (edit ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == sections.length) {
                              return AddSectionButton(
                                sectionCategory: SectionCategory.primary,
                              );
                            }
                            return DraggableSection(
                              sectionCategory: SectionCategory.primary,
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
        sidebar:
            asyncMaterial.isLoading
                ? null
                : Sheet(
                  width: 300,
                  child:
                      Consumer(
                        builder: (context, ref, child) {
                          final sections = ref.watch(
                            sectionsProvider(SectionCategory.secondary),
                          );

                          return ListView.builder(
                            itemCount: sections.length + (edit ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == sections.length) {
                                return AddSectionButton(
                                  sectionCategory: SectionCategory.secondary,
                                );
                              }
                              return DraggableSection(
                                sectionCategory: SectionCategory.secondary,
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
                      ) ??
                      ListView(
                        children: [
                          for (final attribute in material.keys.sorted())
                            Labeled(
                              label: Text(
                                attributes[attribute]?.name ?? attribute,
                              ),
                              child: Text(material[attribute].toString()),
                            ),
                        ],
                      ),
                ),
      ),
    );
  }
}
