import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(BuildContext context) => ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
  visualDensity: VisualDensity.standard,
  scaffoldBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
  searchBarTheme: SearchBarThemeData(
    elevation: WidgetStatePropertyAll(0),
    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
    constraints: BoxConstraints.tight(Size(720, 56)),
  ),
);
