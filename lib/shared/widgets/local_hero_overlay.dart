import 'package:flutter/material.dart';

class LocalHeroOverlay extends StatefulWidget {
  const LocalHeroOverlay({super.key, this.clip = Clip.hardEdge, this.child});

  final Clip clip;
  final Widget? child;

  @override
  State<LocalHeroOverlay> createState() => _LocalHeroOverlayState();
}

class _LocalHeroOverlayState extends State<LocalHeroOverlay> {
  @override
  Widget build(BuildContext context) {
    return Overlay(
      clipBehavior: widget.clip,
      initialEntries: [
        OverlayEntry(canSizeOverlay: true, builder: (context) => widget.child!),
      ],
    );
  }
}
