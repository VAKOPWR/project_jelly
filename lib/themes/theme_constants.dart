import 'package:flutter/material.dart';

ThemeData lightTheme =
    ThemeData(brightness: Brightness.light, colorScheme: ColorScheme.light());

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(background: Colors.grey[900]!));
