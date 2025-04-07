import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(BuildContext context) => ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
  visualDensity: VisualDensity.standard,
  materialTapTargetSize: MaterialTapTargetSize.padded
);
