import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';

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
