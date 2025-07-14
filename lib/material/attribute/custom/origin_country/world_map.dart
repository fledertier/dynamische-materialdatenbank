import 'dart:math';

import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/country.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/focusable_interactive_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorldMap extends StatefulWidget {
  const WorldMap({super.key, required this.highlightedCountries});

  final List<Country> highlightedCountries;

  @override
  State<WorldMap> createState() => _WorldMapState();
}

class _WorldMapState extends State<WorldMap> {
  final controller = FocusableTransformationController();
  final boundingBoxKey = GlobalKey();

  late final MapAttributes attributes;
  late Rect boundingBox;

  @override
  initState() {
    super.initState();
    attributes = MapAttributes(SMapWorld.instructions);
    updateBoundingBox();
  }

  void updateBoundingBox() {
    final points =
        widget.highlightedCountries
            .expand((country) => pointsOfCountry(country, attributes))
            .toList();
    boundingBox = boundingBoxFrom(points);
  }

  List<Offset> pointsOfCountry(Country country, MapAttributes attributes) {
    final instructionsList = instructionsForCountry(country, attributes);
    return instructionsList
        .expand((instructions) => extractPositions(instructions))
        .toList();
  }

  List<List> instructionsForCountry(Country country, MapAttributes attributes) {
    return attributes.drawingInstructions
        .where((e) => e['u'] == country.code.toLowerCase())
        .map((e) => e['i'] as List)
        .toList();
  }

  List<Offset> extractPositions(List<dynamic> instructions) {
    return instructions
        .where((instruction) => instruction != 'c')
        .map((instruction) => instruction.substring(1).split(','))
        .map((coordinates) {
          final x = double.parse(coordinates[0]);
          final y = double.parse(coordinates[1]);
          return Offset(x, y);
        })
        .toList();
  }

  Rect boundingBoxFrom(List<Offset> positions) {
    if (positions.isEmpty) {
      return Rect.fromLTRB(0, 0, 1, 1);
    }
    final minX = positions.map((e) => e.dx).reduce(min);
    final minY = positions.map((e) => e.dy).reduce(min);
    final maxX = positions.map((e) => e.dx).reduce(max);
    final maxY = positions.map((e) => e.dy).reduce(max);
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  void didUpdateWidget(covariant WorldMap oldWidget) {
    if (listEquals(
      oldWidget.highlightedCountries,
      widget.highlightedCountries,
    )) {
      return;
    }
    updateBoundingBox();
    Future.delayed(Duration.zero, () {
      focusCountries();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return AspectRatio(
      aspectRatio: 1.8,
      child: FocusableInteractiveViewer(
        controller: controller,
        maxScale: 100,
        scaleFactor: 100,
        scaleEnabled: false,
        panEnabled: false,
        viewPaddingExponent: 20,
        initialFocusKey: boundingBoxKey,
        initialDuration: Duration.zero,
        initialCurve: Curves.easeInOut,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SimpleMap(
              instructions: SMapWorld.instructions,
              defaultColor: colorScheme.primaryContainer,
              colors: {
                for (final country in widget.highlightedCountries)
                  country.code.toLowerCase(): colorScheme.primary,
              },
              countryBorder: CountryBorder(
                width: 0.5,
                color: colorScheme.primary,
              ),
              callback: (id, name, tapDetails) {
                debugPrint(id);
                focusCountries();
              },
            ),
            AspectRatio(
              aspectRatio: 1 / attributes.aspectRatio,
              child: FractionallySizedBox(
                alignment: boundingBox.toAlignment(),
                widthFactor: boundingBox.width,
                heightFactor: boundingBox.height,
                child: SizedBox(key: boundingBoxKey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void focusCountries() {
    controller.focusOn(
      boundingBoxKey,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

extension RelativeRect on Rect {
  Alignment toAlignment() {
    return Alignment(
      _transformRange(left * (width + 1)),
      _transformRange(top * (height + 1)),
    );
  }

  /// Transforms a value from the range [0, 1] to the range [-1, 1].
  double _transformRange(double value) {
    return value * 2 - 1;
  }
}
