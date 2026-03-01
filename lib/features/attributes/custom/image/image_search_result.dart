import 'dart:ui' show Color;

import 'package:dynamische_materialdatenbank/features/attributes/custom/image/search_image.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/features/color/hex_color.dart';

class ImageSearchResult {
  final List<SearchImage> images;
  final List<Color> colors;
  final Color color;

  const ImageSearchResult({
    required this.images,
    required this.colors,
    required this.color,
  });

  factory ImageSearchResult.fromJson(Json json) {
    final images = (json['images'] as List)
        .map((e) => SearchImage.fromJson(e))
        .toList();
    final colors = (json['colors'] as List)
        .map((e) => HexColor.fromHex(e))
        .toList();
    final color = HexColor.fromHex(json['color']);
    return ImageSearchResult(images: images, colors: colors, color: color);
  }

  Json toJson() {
    return {
      'images': images.map((e) => e.toJson()).toList(),
      'colors': colors.map((e) => e.toHex()).toList(),
      'color': color.toHex(),
    };
  }
}
