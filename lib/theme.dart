import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(BuildContext context) => ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(TextTheme.of(context)),
  visualDensity: VisualDensity.standard,
  searchBarTheme: SearchBarThemeData(
    elevation: WidgetStatePropertyAll(0),
    constraints: BoxConstraints(maxWidth: 720, minHeight: 56),
  ),
  searchViewTheme: SearchViewThemeData(
    constraints: BoxConstraints(minHeight: 0),
    shrinkWrap: true,
  ),
  sliderTheme: SliderThemeData(
    year2023: false,
    overlayShape: SliderComponentShape.noOverlay,
    showValueIndicator: ShowValueIndicator.always,
    trackHeight: 3,
    padding: EdgeInsets.symmetric(horizontal: 2),
    thumbSize: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed) ||
          states.contains(WidgetState.focused)) {
        return Size(2, 24);
      }
      return Size(4, 24);
    }),
  ),
);
