import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/image/image_search_service.dart';
import 'package:dynamische_materialdatenbank/material/attribute/image/web_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../types.dart' hide Material;
import '../../edit_mode_button.dart';
import '../../material_service.dart';
import '../attribute_card.dart';
import '../attribute_label.dart';
import 'constrained_image.dart';

class ImageCard extends ConsumerStatefulWidget {
  const ImageCard(this.material, {super.key});

  final Json material;

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
    final value = widget.material[Attributes.images] as List?;
    images = value != null ? List<Json>.from(value) : [];
    super.initState();
  }

  void searchImages() async {
    final name = widget.material[Attributes.name] as String;
    final result = await ref
        .read(imageSearchServiceProvider)
        .searchImages(name);
    final foundImages =
        result?.images.map((image) {
          return {"thumbnailLink": image.thumbnailLink, "link": image.link};
        }).toList();

    if (foundImages?.isNotEmpty ?? false) {
      setMainImage(foundImages!.first);
      addImages(foundImages);
    }
  }

  void addImages(List<Json> foundImages) {
    setState(() {
      images.addAll(foundImages);
    });
    ref.read(materialServiceProvider).updateMaterial({
      Attributes.id: widget.material[Attributes.id],
      Attributes.images: images,
    });
  }

  void setMainImage(Json image) {
    final url = image["thumbnailLink"] as String? ?? image["link"] as String?;
    if (url == null) return;
    ref.read(materialServiceProvider).updateMaterial({
      Attributes.id: widget.material[Attributes.id],
      Attributes.image: url,
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editModeProvider);
    final attribute = ref.watch(attributeProvider(Attributes.images));
    final selectedImage = images.elementAtOrNull(selectedIndex);

    return AttributeCard(
      label: AttributeLabel(label: attribute?.name),
      columns: 3,
      childPadding:
          images.isNotEmpty
              ? EdgeInsets.all(
                padding,
              ).copyWith(right: padding - scrollbarWidth)
              : EdgeInsets.all(padding),
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
                              ? buildImage(context, selectedImage)
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

  Widget buildImage(BuildContext context, Json image) {
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
