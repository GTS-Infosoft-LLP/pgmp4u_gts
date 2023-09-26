import 'package:flutter/material.dart';

class AppColor {
  static const Color purpule = Color(0xff463b97);
  static const Color green = Color(0xff72a258);
  static const Color darkText = Color(0xff424b53);
  static const Color lightText = Color(0xff989d9e);

  static LinearGradient appGradient = LinearGradient(colors: [
    Color(0xff4B5BE2),
    Color(0xff2135D9),
  ]);

  static LinearGradient greenGradient = LinearGradient(colors: [
    Color.fromARGB(255, 138, 179, 116),
    Color.fromARGB(255, 92, 160, 55),
  ]);

  static LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 108, 120, 225),
      Color(0xff2135D9),
    ],
  );
}
