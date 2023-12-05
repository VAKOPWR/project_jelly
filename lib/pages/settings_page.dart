import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_jelly/pages/controller/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Theme:'),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: [
                    RadioListTile<ThemeModeOption>(
                      title: Text('Light'),
                      value: ThemeModeOption.Light,
                      groupValue: themeProvider.themeModeOption,
                      onChanged: (ThemeModeOption? value) {
                        if (value != null) {
                          setState(() {
                            themeProvider.setThemeMode(value);
                          });
                        }
                      },
                    ),
                    RadioListTile<ThemeModeOption>(
                      title: Text('Dark'),
                      value: ThemeModeOption.Dark,
                      groupValue: themeProvider.themeModeOption,
                      onChanged: (ThemeModeOption? value) {
                        if (value != null) {
                          setState(() {
                            themeProvider.setThemeMode(value);
                          });
                        }
                      },
                    ),
                    RadioListTile<ThemeModeOption>(
                      title: Text('Custom'),
                      value: ThemeModeOption.Custom,
                      groupValue: themeProvider.themeModeOption,
                      onChanged: (ThemeModeOption? value) {
                        if (value != null) {
                          setState(() {
                            themeProvider.setThemeMode(value);
                          });
                        }
                      },
                    ),
                    RadioListTile<ThemeModeOption>(
                      title: Text('Automatic'),
                      value: ThemeModeOption.Automatic,
                      groupValue: themeProvider.themeModeOption,
                      onChanged: (ThemeModeOption? value) {
                        if (value != null) {
                          setState(() {
                            themeProvider.setThemeMode(value);
                          });
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
