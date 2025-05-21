import 'dart:math';

import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_service.dart';
import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../material_provider.dart';
import 'constrained_image.dart';
import 'image_search_service.dart';
import 'web_image.dart';

class ImageCard extends ConsumerStatefulWidget {
  const ImageCard({super.key, required this.materialId, required this.size});

  final String materialId;
  final CardSize size;

  @override
  ConsumerState<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends ConsumerState<ImageCard> {
  late final List<Json> images;
  int selectedIndex = 0;

  final double padding = 16;
  final double scrollbarWidth = 14;

  @override
  void initState() {
    super.initState();
    final value = ref.watch(
      materialAttributeValueProvider(
        AttributeArgument(
          materialId: widget.materialId,
          attributeId: Attributes.images,
        ),
      ),
    );
    images = value != null ? List<Json>.from(value) : [];
  }

  Future<String> materialName() async {
    final material = await ref.read(materialProvider(widget.materialId).future);
    return material[Attributes.name];
  }

  void searchImages() async {
    final name = await materialName();
    final result = await ref
        .read(imageSearchServiceProvider)
        .searchImages(name);
    final foundImages =
        result?.images.map((image) {
          return {"thumbnailLink": image.thumbnailLink, "link": image.link};
        }).toList();

    if (foundImages?.isNotEmpty ?? false) {
      addImages(foundImages!);
      setMainImage();
    }
  }

  void addImages(List<Json> foundImages) {
    setState(() {
      images.addAll(foundImages);
    });
    ref.read(materialServiceProvider).updateMaterialById(widget.materialId, {
      Attributes.images: images,
    });
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
      selectedIndex = min(selectedIndex, images.length - 1);
    });
    ref.read(materialServiceProvider).updateMaterialById(widget.materialId, {
      Attributes.images: images,
    });
  }

  void setMainImage([int index = 0]) {
    final image = images[index];
    final url = image["thumbnailLink"] as String? ?? image["link"] as String?;
    if (url == null) return;
    setState(() {
      images.removeAt(index);
      images.insert(0, image);
      selectedIndex = 0;
    });
    ref.read(materialServiceProvider).updateMaterialById(widget.materialId, {
      Attributes.image: url,
      Attributes.images: images,
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final selectedImage = images.elementAtOrNull(selectedIndex);

    return AttributeCard(
      label: AttributeLabel(attribute: Attributes.images),
      columns: 3,
      childPadding: EdgeInsets.all(padding),
      child: AspectRatio(
        aspectRatio: 1.6,
        child:
            images.isNotEmpty
                ? Row(
                  spacing: padding,
                  children: [
                    Expanded(
                      child:
                          selectedImage != null
                              ? buildImage(context, selectedImage, edit)
                              : SizedBox(),
                    ),
                    buildThumbnails(context),
                  ],
                )
                : Center(
                  child: FilledButton.icon(
                    icon: Icon(Icons.search),
                    label: Text("Search images"),
                    onPressed: searchImages,
                  ),
                ),
      ),
    );
  }

  Widget buildImage(BuildContext context, Json image, bool edit) {
    final thumbnail = image["thumbnailLink"] as String?;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnail != null)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ConstrainedImage(image: NetworkImage(thumbnail)),
            ),
          ),
        WebImage(
          src: image["link"],
          objectFit: BoxFit.contain,
          borderRadius: BorderRadius.circular(16),
        ),
        if (edit)
          Positioned(
            top: 8,
            bottom: 8,
            left: 8,
            child: Column(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filledTonal(
                  icon: Icon(Symbols.search),
                  tooltip: "Search images",
                  onPressed: () => searchImages(),
                ),
                IconButton.filledTonal(
                  icon: Icon(Symbols.imagesmode),
                  tooltip: "Set as main image",
                  onPressed: () => setMainImage(selectedIndex),
                ),
                IconButton.filledTonal(
                  icon: Icon(Symbols.delete),
                  tooltip: "Remove image",
                  onPressed: () => removeImage(selectedIndex),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildThumbnails(BuildContext context) {
    return SizedBox(
      width: 48 + scrollbarWidth,
      child: ListView.separated(
        padding: EdgeInsets.only(right: scrollbarWidth),
        itemCount: images.length,
        itemBuilder: buildThumbnail,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 3);
        },
      ),
    );
  }

  Widget buildThumbnail(BuildContext context, int index) {
    final thumbnailLink = images[index]["thumbnailLink"];
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Image.network(thumbnailLink, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
