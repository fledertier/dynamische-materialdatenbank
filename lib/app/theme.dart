import 'package:flutter/material.dart';

ThemeData buildTheme(BuildContext context, Brightness brightness) {
  return ThemeData(
    fontFamily: 'Roboto',
    brightness: brightness,
    visualDensity: VisualDensity.standard,
    searchBarTheme: SearchBarThemeData(
      elevation: WidgetStatePropertyAll(0),
      constraints: BoxConstraints(maxWidth: 720, minHeight: 56),
    ),
    searchViewTheme: SearchViewThemeData(shrinkWrap: true),
    sliderTheme: SliderThemeData(
      // ignore: deprecated_member_use
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
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    menuButtonTheme: MenuButtonThemeData(
      style: MenuItemButton.styleFrom(minimumSize: Size(140, 48)),
    ),
  );
}

extension ColorSchemeExtension on ColorScheme {
  Color get water {
    return brightness == Brightness.light
        ? Color(0xffc2e8ff)
        : Color(0xff004d67);
  }

  Color get onWater {
    return brightness == Brightness.light
        ? Color(0xff001e2c)
        : Color(0xffc2e8ff);
  }
}
