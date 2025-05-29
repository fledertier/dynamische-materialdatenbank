import 'dart:ui_web';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart.' hide Text;

class WebImage extends StatelessWidget {
  final String src;
  final String? alt;
  final double? width;
  final double? height;
  final BoxFit objectFit;
  final BorderRadius borderRadius;

  const WebImage({
    super.key,
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.objectFit = BoxFit.none,
    this.borderRadius = BorderRadius.zero,
  });

  String get viewType => 'img-${src.hashCode}';

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const Text('WebImage is only supported on Flutter Web');
    }

    platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final div =
          HTMLDivElement()
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.display = "flex"
            ..style.alignItems = "center"
            ..style.justifyContent = "center";

      final img =
          HTMLImageElement()
            ..src = src
            ..alt = alt ?? ''
            ..style.width = "auto"
            ..style.height = "auto"
            ..style.maxWidth = '100%'
            ..style.maxHeight = '100%'
            ..style.objectFit = objectFit.toCss()
            ..style.borderRadius = borderRadius.toCss();

      return div..append(img);
    });

    return SizedBox(
      width: width,
      height: height,
      child: HtmlElementView(viewType: viewType),
    );
  }
}

extension BoxFitCss on BoxFit {
  String toCss() {
    return switch (this) {
      BoxFit.contain || BoxFit.fitHeight || BoxFit.fitWidth => 'contain',
      BoxFit.cover => 'cover',
      BoxFit.fill => 'fill',
      BoxFit.none => 'none',
      BoxFit.scaleDown => 'scale-down',
    };
  }
}

extension BorderRadiusCss on BorderRadius {
  String toCss() {
    if (isUniform) {
      return '${topLeft.x}px';
    }
    return '${topLeft.x}px ${topRight.x}px ${bottomRight.x}px ${bottomLeft.x}px';
  }

  bool get isUniform {
    return topLeft == topRight &&
        topLeft == bottomRight &&
        topLeft == bottomLeft;
  }
}
