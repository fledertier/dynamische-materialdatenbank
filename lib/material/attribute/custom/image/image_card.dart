import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_card.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_label.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/material/attribute/cards.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/image/constrained_image.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/image/image_search_service.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/image/web_image.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';
import 'package:dynamische_materialdatenbank/material/edit_mode_button.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class Fields {
  static const link = '0197c159-7074-7813-ae3b-d8ccc98ee7c2';
  static const thumbnailLink = '0197c159-299d-791e-9527-1bd445e2401e';
}

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
    final value = ref.read(
      jsonValueProvider(
        AttributeArgument(
          materialId: widget.materialId,
          attributePath: AttributePath(Attributes.images),
        ),
      ),
    );
    images = value != null ? List<Json>.from(value) : [];
  }

  String? materialName() {
    final argument = AttributeArgument(
      materialId: widget.materialId,
      attributePath: AttributePath(Attributes.name),
    );
    final name = ref.read(valueProvider(argument)) as TranslatableText?;
    return name?.valueDe ?? name?.valueEn;
  }

  void searchImages() async {
    final name = materialName();
    if (name == null) return;
    final result = await ref
        .read(imageSearchServiceProvider)
        .searchImages(name);
    final foundImages =
        result?.images.map((image) {
          return {
            Fields.thumbnailLink:
                TranslatableText(valueDe: image.thumbnailLink).toJson(),
            Fields.link: TranslatableText(valueDe: image.link).toJson(),
          };
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
    ref.read(materialProvider(widget.materialId).notifier).updateMaterial({
      Attributes.images: images,
    });
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
      selectedIndex = selectedIndex.clamp(0, images.length - 1);
    });
    ref.read(materialProvider(widget.materialId).notifier).updateMaterial({
      Attributes.images: images,
    });
  }

  void setMainImage([int index = 0]) {
    final image = images[index];
    setState(() {
      images.removeAt(index);
      images.insert(0, image);
      selectedIndex = 0;
    });
    ref.read(materialProvider(widget.materialId).notifier).updateMaterial({
      Attributes.image: image[Fields.thumbnailLink],
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
      label: AttributeLabel(attributeId: Attributes.images),
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
                    label: Text('Search images'),
                    onPressed: searchImages,
                  ),
                ),
      ),
    );
  }

  Widget buildImage(BuildContext context, Json image, bool edit) {
    final thumbnail = image[Fields.thumbnailLink]?['valueDe'] as String?;
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
          src: image[Fields.link]?['valueDe'] as String? ?? '',
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
                  tooltip: 'Search images',
                  onPressed: () => searchImages(),
                ),
                IconButton.filledTonal(
                  icon: Icon(Symbols.imagesmode),
                  tooltip: 'Set as main image',
                  onPressed: () => setMainImage(selectedIndex),
                ),
                IconButton.filledTonal(
                  icon: Icon(Symbols.delete),
                  tooltip: 'Remove image',
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
    final thumbnailLink =
        (images[index][Fields.thumbnailLink] ??
                images[index][Fields.link])?['valueDe']
            as String?;
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
          child: Image.network(thumbnailLink ?? '', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
