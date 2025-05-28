import 'package:dynamische_materialdatenbank/material/attribute/custom/image/web_image.dart';
import 'package:flutter/material.dart';

class Favicon extends StatelessWidget {
  const Favicon(this.url, {super.key, this.size = 24.0, this.dpr = 2.0});

  final String url;
  final double size;
  final double dpr;

  @override
  Widget build(BuildContext context) {
    final sz = (size * dpr).round();
    return WebImage(
      src: 'http://www.google.com/s2/favicons?domain=$url&sz=$sz',
      objectFit: BoxFit.contain,
      width: size,
      height: size,
    );
  }
}
