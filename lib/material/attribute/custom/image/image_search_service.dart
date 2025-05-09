import 'dart:async';
import 'dart:ui' show Color;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../types.dart';
import '../../color/hex_color.dart';

final imageSearchServiceProvider = Provider((ref) => ImageSearchService());

class ImageSearchService {
  Future<ImageSearchResult?> searchImages(String query) async {
    final result = await FirebaseFunctions.instanceFor(
      region: region,
    ).httpsCallable(Functions.search).call({"query": query});
    final json = result.data as Json?;
    if (json == null) {
      return null;
    }
    return ImageSearchResult.fromJson(json);
  }
}

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
    final images =
        (json['images'] as List).map((e) => SearchImage.fromJson(e)).toList();
    final colors =
        (json['colors'] as List).map((e) => HexColor.fromHex(e)).toList();
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

class SearchImage {
  final String thumbnailLink;
  final int thumbnailWidth;
  final int thumbnailHeight;
  final String contextLink;
  final String link;
  final int width;
  final int height;
  final int byteSize;

  const SearchImage({
    required this.thumbnailLink,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
    required this.contextLink,
    required this.link,
    required this.width,
    required this.height,
    required this.byteSize,
  });

  factory SearchImage.fromJson(Json json) {
    return SearchImage(
      thumbnailLink: json['thumbnailLink'],
      thumbnailWidth: json['thumbnailWidth'],
      thumbnailHeight: json['thumbnailHeight'],
      contextLink: json['contextLink'],
      link: json['link'],
      width: json['width'],
      height: json['height'],
      byteSize: json['byteSize'],
    );
  }

  Json toJson() {
    return {
      'thumbnailLink': thumbnailLink,
      'thumbnailWidth': thumbnailWidth,
      'thumbnailHeight': thumbnailHeight,
      'contextLink': contextLink,
      'link': link,
      'width': width,
      'height': height,
      'byteSize': byteSize,
    };
  }
}
