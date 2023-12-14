import 'package:flutter/material.dart';

class ThemeColors {
  static final dark = ThemeData.dark().copyWith(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.purple,
      primaryColorDark: Colors.purple[800],
      primaryColorLight: Colors.purple[200],
      colorScheme: const ColorScheme.dark());

  static final light = ThemeData.light().copyWith(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      primaryColorDark: Colors.purple[800],
      primaryColorLight: Colors.purple[200],
      colorScheme: ColorScheme.light());
}
