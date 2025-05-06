import 'dart:async';

import 'package:flutter/material.dart';

class ConstrainedImage extends StatelessWidget {
  const ConstrainedImage({super.key, required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: aspectRatio(),
      builder: (context, snapshot) {
        final aspectRatio = snapshot.data;
        if (aspectRatio == null) {
          return SizedBox();
        }
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Image(image: image, fit: BoxFit.cover),
        );
      },
    );
  }

  Future<double> aspectRatio() async {
    final info = await resolveImage(image);
    return info.image.width / info.image.height;
  }

  Future<ImageInfo> resolveImage(ImageProvider imageProvider) {
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((info, _) {
      completer.complete(info);
    });
    imageProvider.resolve(ImageConfiguration()).addListener(listener);
    return completer.future;
  }
}
