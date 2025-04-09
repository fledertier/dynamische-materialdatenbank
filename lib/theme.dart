import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(BuildContext context) => ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
  visualDensity: VisualDensity.standard,
  searchBarTheme: SearchBarThemeData(
    elevation: WidgetStatePropertyAll(0),
    constraints: BoxConstraints(maxWidth: 720, minHeight: 56),
  ),
  searchViewTheme: SearchViewThemeData(
    constraints: BoxConstraints(minHeight: 0),
    shrinkWrap: true,
  ),
);
