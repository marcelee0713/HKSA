import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primary = Color(0xff00402B);
  static const Color secondary = Color(0xff72B18B);

  // Either of these will be in our fonts or background
  static const Color accentDarkWhite = Color(0xffd9d9d9);
  static const Color accentWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color accentBlack = Colors.black;
}

class Palette {
  static const MaterialColor royalGreen = MaterialColor(
    0xff00402b, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which does not require a swatch.
    <int, Color>{
      50: Color(0xffce5641), //10%
      100: Color(0xffb74c3a), //20%
      200: Color(0xffa04332), //30%
      300: Color(0xff89392b), //40%
      400: Color(0xff733024), //50%
      500: Color(0xff00402b), //60%
      600: Color(0xff451c16), //70%
      700: Color(0xff2e130e), //80%
      800: Color(0xff170907), //90%
      900: Color(0xff000000), //100%
    },
  );
}
