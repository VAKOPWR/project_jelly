import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum ThemeModeOption { Automatic, Light, Dark, Custom }

enum MapModeOption { Automatic, Light, Dark }

class ThemeController extends GetxController {
  ThemeData _themeData =
      ThemeData(brightness: Brightness.light, colorScheme: ColorScheme.light());
  ThemeModeOption _themeModeOption = ThemeModeOption.Automatic;
  MapModeOption _mapModeOption = MapModeOption.Automatic;

  ThemeData get themeData => _themeData;
  ThemeModeOption get themeModeOption => _themeModeOption;
  MapModeOption get mapModeOption => _mapModeOption;
  final box = GetStorage();

  void loadThemePreferences() {
    // box.write('theme_mode', 0);

    final themeModeIndex =
        box.read('theme_mode') ?? ThemeModeOption.Automatic.index;
    _themeModeOption = ThemeModeOption.values[themeModeIndex];

    loadCustomTheme();
    update();
  }

  void loadCustomTheme() {
    List? customTheme = box.read('custom_theme');
    if (customTheme != null && customTheme.length == 4) {
      ThemeData basicTheme = ThemeData(
          brightness: Brightness.light, colorScheme: ColorScheme.light());
      if (getContrastColor(Color(customTheme[2])) == Colors.white) {
        basicTheme = ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(background: Colors.grey[900]!));
      }
      _themeData = basicTheme.copyWith(
          colorScheme: ColorScheme.light(
              primary: Color(customTheme[0]),
              secondary: Color(customTheme[1]),
              background: Color(customTheme[2]),
              onPrimary: getContrastColor(Color(customTheme[0])),
              onSecondary: getContrastColor(Color(customTheme[1])),
              onBackground: getContrastColor(Color(customTheme[2]))));
      _mapModeOption = MapModeOption.values[customTheme[3]];
    } else {
      _themeData = ThemeData(
          brightness: Brightness.light, colorScheme: ColorScheme.light());
      _mapModeOption = MapModeOption.Light;
    }
    update();
  }

  void resetCustomTheme() {
    _themeData = ThemeData(
        brightness: Brightness.light, colorScheme: ColorScheme.light());
    _mapModeOption = MapModeOption.Light;
    saveCustomTheme();
  }

  void saveThemePreferences() {
    box.write('theme_mode', _themeModeOption.index);
  }

  void saveCustomTheme() {
    box.write(
      'custom_theme',
      [
        _themeData.colorScheme.primary.value,
        _themeData.colorScheme.secondary.value,
        _themeData.colorScheme.background.value,
        _mapModeOption.index
      ],
    );
  }

  void setThemeMode(ThemeModeOption option, MapModeOption mapModeOption) {
    _themeModeOption = option;
    _mapModeOption = mapModeOption;
    saveThemePreferences();
    if (option == ThemeModeOption.Custom) {
      saveCustomTheme();
    }
    update();
  }

  void setCustomTheme(Color primary, Color secondary, Color background) {
    ThemeData basicTheme = ThemeData(
        brightness: Brightness.light, colorScheme: ColorScheme.light());
    if (getContrastColor(background) == Colors.white) {
      basicTheme = ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(background: Colors.grey[900]!));
    }
    _themeData = basicTheme.copyWith(
      colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
          background: background,
          onPrimary: getContrastColor(primary),
          onSecondary: getContrastColor(secondary),
          onBackground: getContrastColor(background)),
    );
    _themeModeOption = ThemeModeOption.Custom;
    saveThemePreferences();
    update();
  }

  void setCustomPrimaryColor(Color color) {
    _themeData = _themeData.copyWith(
      colorScheme: _themeData.colorScheme
          .copyWith(primary: color, onPrimary: getContrastColor(color)),
    );
    saveCustomTheme();
    update();
  }

  void setCustomSecondaryColor(Color color) {
    _themeData = _themeData.copyWith(
      colorScheme: _themeData.colorScheme
          .copyWith(secondary: color, onSecondary: getContrastColor(color)),
    );
    saveCustomTheme();
    update();
  }

  void setCustomBackgroundColor(Color color) {
    ThemeData basicTheme = ThemeData(
        brightness: Brightness.light, colorScheme: ColorScheme.light());
    if (getContrastColor(color) == Colors.white) {
      basicTheme = ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(background: Colors.grey[900]!));
    }
    _themeData = basicTheme.copyWith(
        colorScheme: _themeData.colorScheme.copyWith(
            background: color, onBackground: getContrastColor(color)));
    saveCustomTheme();
    update();
  }

  void setSelectedMapStyle(MapModeOption newMapModeOption) {
    if (newMapModeOption != _mapModeOption) {
      _mapModeOption = newMapModeOption;
      saveCustomTheme();
      update();
    }
  }

  Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
