import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum ThemeModeOption { Automatic, Light, Dark, Custom }

class ThemeController extends GetxController {
  ThemeData _themeData = ThemeData.light();
  ThemeModeOption _themeModeOption = ThemeModeOption.Automatic;

  ThemeData get themeData => _themeData;
  ThemeModeOption get themeModeOption => _themeModeOption;

  Future<void> loadThemePreferences() async {
    final box = GetStorage();
    await box.initStorage;

    final themeModeIndex =
        box.read('theme_mode') ?? ThemeModeOption.Automatic.index;
    _themeModeOption = ThemeModeOption.values[themeModeIndex];

    if (_themeModeOption == ThemeModeOption.Custom) {
      final customTheme = box.read<List<int>>('custom_theme');
      if (customTheme != null && customTheme.length == 3) {
        _themeData = ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(customTheme[0]),
            secondary: Color(customTheme[1]),
          ),
          canvasColor: Color(customTheme[2]),
        );
      }
    }
    update();
  }

  Future<void> saveThemePreferences() async {
    final box = GetStorage();
    await box.initStorage;

    box.write('theme_mode', _themeModeOption.index);

    if (_themeModeOption == ThemeModeOption.Custom) {
      box.write(
        'custom_theme',
        [
          _themeData.colorScheme.primary.value,
          _themeData.colorScheme.secondary.value,
          _themeData.canvasColor.value,
        ],
      );
    }
    update();
  }

  void setThemeMode(ThemeModeOption option) {
    _themeModeOption = option;
    saveThemePreferences();
    update();
  }

  void setCustomTheme(Color primary, Color secondary, Color canvas) {
    _themeData = ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
      ),
      canvasColor: canvas,
    );
    _themeModeOption = ThemeModeOption.Custom;
    saveThemePreferences();
    update();
  }
}
