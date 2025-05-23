import 'package:dynamische_materialdatenbank/localization/language_button.dart';
import 'package:dynamische_materialdatenbank/material/section/draggable_cards_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app_scaffold.dart';
import '../app/navigation.dart';
import '../attributes/attribute_provider.dart';
import '../constants.dart';
import '../header/header.dart';
import '../widgets/sheet.dart';
import 'attribute/attribute_card_button.dart';
import 'attribute/attribute_card_dialog.dart';
import 'attribute/cards.dart';
import 'edit_mode_button.dart';
import 'material_provider.dart';
import 'section/draggable_section.dart';
import 'section/section_button.dart';

class MaterialDetailPage extends ConsumerStatefulWidget {
  const MaterialDetailPage({super.key, required this.materialId});

  final String materialId;

  @override
  ConsumerState<MaterialDetailPage> createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends ConsumerState<MaterialDetailPage> {
  bool showDialog = false;

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final asyncAttributes = ref.watch(attributesProvider);
    final asyncMaterial = ref.watch(materialProvider(widget.materialId));
    final material = asyncMaterial.value ?? {};

    final isLoading = asyncMaterial.isLoading || asyncAttributes.isLoading;

    final sections = CardSections.fromJson(
      material[Attributes.cardSections] ?? {},
    );

    return ProviderScope(
      overrides: [
        sectionsProvider(
          SectionCategory.primary,
        ).overrideWith((ref) => sections.primary),
        sectionsProvider(
          SectionCategory.secondary,
        ).overrideWith((ref) => sections.secondary),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          return Stack(
            children: [
              AppScaffold(
                header: Header(
                  center: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [LanguageButton(), EditModeButton()],
                  ),
                ),
                navigation: Navigation(page: Pages.materials),
                floatingActionButton:
                    edit
                        ? AttributeCardButton(
                          materialId: widget.materialId,
                          onPressed: () {
                            setState(() {
                              showDialog = true;
                            });
                          },
                        )
                        : null,
                body:
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Center(
                          child: PrimarySections(materialId: widget.materialId),
                        ),
                sidebar:
                    isLoading
                        ? null
                        : Sheet(
                          width: 300,
                          child: SecondarySections(
                            materialId: widget.materialId,
                          ),
                        ),
              ),
              if (showDialog)
                AttributeCardDialog(
                  materialId: widget.materialId,
                  sizes: {CardSize.large},
                  onClose: () {
                    setState(() {
                      showDialog = false;
                    });
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class PrimarySections extends ConsumerWidget {
  const PrimarySections({super.key, required this.materialId});

  final String materialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);

    final edit = ref.watch(editModeProvider);
    final sections = ref.watch(sectionsProvider(SectionCategory.primary));

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 32),
      itemCount: sections.length + (edit ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == sections.length) {
          return SectionButton(sectionCategory: SectionCategory.primary);
        }
        return DraggableSection(
          sectionCategory: SectionCategory.primary,
          sectionIndex: index,
          materialId: materialId,
          textStyle: textTheme.headlineMedium?.copyWith(fontFamily: 'Lexend'),
          labelPadding: const EdgeInsets.only(
            top: 0,
            left: 8,
            right: 8,
            bottom: 8,
          ),
          padding: const EdgeInsets.all(16),
          itemMargin: const EdgeInsets.all(8),
          itemBuilder: (context, item) {
            return CardFactory.getOrCreate(item, materialId);
          },
        );
      },
    );
  }
}

class SecondarySections extends ConsumerWidget {
  const SecondarySections({super.key, required this.materialId});

  final String materialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);

    final edit = ref.read(editModeProvider);
    final sections = ref.watch(sectionsProvider(SectionCategory.secondary));

    return ListView.builder(
      itemCount: sections.length + (edit ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == sections.length) {
          return SectionButton(sectionCategory: SectionCategory.secondary);
        }
        return DraggableSection(
          sectionCategory: SectionCategory.secondary,
          sectionIndex: index,
          materialId: materialId,
          textStyle: textTheme.titleMedium?.copyWith(fontFamily: 'Lexend'),
          labelPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemBuilder: (context, item) {
            return CardFactory.getOrCreate(item, materialId, CardSize.small);
          },
        );
      },
    );
  }
}
