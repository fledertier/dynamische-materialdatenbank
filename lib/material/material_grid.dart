import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/color/color_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:dynamische_materialdatenbank/query/query_provider.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/directional_menu_anchor.dart';
import 'package:dynamische_materialdatenbank/widgets/hover_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class MaterialGrid extends StatelessWidget {
  const MaterialGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final items = ref.watch(queriedMaterialsProvider).value ?? [];
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return MaterialItem(item: items[index]);
          },
        );
      },
    );
  }
}

class MaterialItem extends ConsumerWidget {
  const MaterialItem({super.key, required this.item});

  final Json item;

  String get id => item[Attributes.id];

  String get name => TranslatableText.fromJson(item[Attributes.name]).value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    final color = ref.watch(materialColorProvider(name));

    return Card.filled(
      clipBehavior: Clip.antiAlias,
      color: color ?? colorScheme.surfaceContainerHighest,
      child: InkWell(
        hoverColor: colorScheme.scrim.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          context.pushNamed(Pages.material, pathParameters: {'materialId': id});
        },
        child: HoverBuilder(
          builder: (context, hovered, child) {
            final image = item[Attributes.image];
            return Stack(
              children: [
                if (image != null)
                  Positioned.fill(
                    child: Image.network(image, fit: BoxFit.cover),
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: MaterialContextMenu(materialId: id, visible: hovered),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12).copyWith(top: 32),
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MaterialContextMenu extends ConsumerWidget {
  const MaterialContextMenu({
    super.key,
    required this.materialId,
    this.visible = true,
  });

  final String materialId;
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DirectionalMenuAnchor(
      directionality: TextDirection.rtl,
      builder: (context, controller, child) {
        return IconButton(
          onPressed: controller.toggle,
          icon: Visibility.maintain(
            visible: visible || controller.isOpen,
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        );
      },
      style: MenuStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            ref.read(materialProvider(materialId).notifier).deleteMaterial();
          },
          requestFocusOnHover: false,
          leadingIcon: Icon(Symbols.delete),
          child: Text('Delete'),
        ),
      ],
    );
  }
}
