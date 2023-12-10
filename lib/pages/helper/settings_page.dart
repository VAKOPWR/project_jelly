import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/controller/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Get.find<ThemeController>();
    Color primaryColor = themeProvider.themeData.colorScheme.primary;
    Color secondaryColor = themeProvider.themeData.colorScheme.secondary;
    Color backgroundColor = themeProvider.themeData.colorScheme.background;
    final box = GetStorage();

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
            child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Theme:',
                  style: TextStyle(fontSize: 20),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: [
                        RadioListTile<ThemeModeOption>(
                          title: Text('Automatic'),
                          value: ThemeModeOption.Automatic,
                          groupValue: themeProvider.themeModeOption,
                          onChanged: (ThemeModeOption? value) {
                            if (value != null) {
                              setState(() {
                                themeProvider.setThemeMode(
                                    value, MapModeOption.Automatic);
                              });
                            }
                          },
                        ),
                        RadioListTile<ThemeModeOption>(
                          title: Text('Light'),
                          value: ThemeModeOption.Light,
                          groupValue: themeProvider.themeModeOption,
                          onChanged: (ThemeModeOption? value) {
                            if (value != null) {
                              setState(() {
                                themeProvider.setThemeMode(
                                    value, MapModeOption.Light);
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
                                themeProvider.setThemeMode(
                                    value, MapModeOption.Dark);
                              });
                            }
                          },
                        ),
                        RadioListTile<ThemeModeOption>(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Custom'),
                              themeProvider.themeModeOption ==
                                      ThemeModeOption.Custom
                                  ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          themeProvider.resetCustomTheme();
                                          primaryColor = themeProvider
                                              .themeData.colorScheme.primary;
                                          secondaryColor = themeProvider
                                              .themeData.colorScheme.secondary;
                                          backgroundColor = themeProvider
                                              .themeData.colorScheme.background;
                                          themeProvider.setThemeMode(
                                              ThemeModeOption.Custom,
                                              MapModeOption.Light);
                                        });
                                      },
                                      child: Text(
                                        'Reset',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          width: 2.0,
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          value: ThemeModeOption.Custom,
                          groupValue: themeProvider.themeModeOption,
                          onChanged: (ThemeModeOption? value) {
                            if (value != null) {
                              setState(() {
                                themeProvider.setThemeMode(
                                    value,
                                    box.read('custom_theme') != null
                                        ? MapModeOption
                                            .values[box.read('custom_theme')[3]]
                                        : MapModeOption.Light);
                                themeProvider.loadCustomTheme();
                              });
                            }
                          },
                        ),
                        Visibility(
                          visible: themeProvider.themeModeOption ==
                              ThemeModeOption.Custom,
                          child: Column(
                            children: [
                              ColorPickerTile(
                                title: 'Primary Color       ',
                                color: primaryColor,
                                onColorChanged: (Color color) {
                                  setState(() {
                                    primaryColor = color;
                                    themeProvider.setCustomPrimaryColor(color);
                                  });
                                },
                              ),
                              Divider(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                height: 1,
                              ),
                              ColorPickerTile(
                                title: 'Secondary Color  ',
                                color: secondaryColor,
                                onColorChanged: (Color color) {
                                  setState(() {
                                    themeProvider
                                        .setCustomSecondaryColor(color);
                                    secondaryColor = color;
                                  });
                                },
                              ),
                              Divider(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                height: 1,
                              ),
                              ColorPickerTile(
                                title: 'Background Color',
                                color: backgroundColor,
                                onColorChanged: (Color color) {
                                  setState(() {
                                    themeProvider
                                        .setCustomBackgroundColor(color);
                                    backgroundColor = color;
                                  });
                                },
                              ),
                              Divider(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                height: 1,
                              ),
                              SizedBox(height: 8.0),
                              ListTile(
                                title: Text('Map Style'),
                                subtitle: Column(children: [
                                  SizedBox(height: 15.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildMapStyleOption(
                                          'Light',
                                          MapModeOption.Light,
                                          'assets/map/light_map_image.jpg',
                                          themeProvider.mapModeOption ==
                                              MapModeOption.Light,
                                          Theme.of(context)
                                              .colorScheme
                                              .onBackground, () {
                                        themeProvider.setSelectedMapStyle(
                                            MapModeOption.Light);
                                        setState(() {});
                                      }),
                                      _buildMapStyleOption(
                                          'Dark',
                                          MapModeOption.Dark,
                                          'assets/map/dark_map_image.jpg',
                                          themeProvider.mapModeOption ==
                                              MapModeOption.Dark,
                                          Theme.of(context)
                                              .colorScheme
                                              .onBackground, () {
                                        themeProvider.setSelectedMapStyle(
                                            MapModeOption.Dark);
                                        setState(() {});
                                      }),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        )));
  }
}

Widget _buildMapStyleOption(
  String styleName,
  MapModeOption mapModeOption,
  String imagePath,
  bool isSelected,
  Color onBackground,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          styleName,
          style: TextStyle(
            color: onBackground,
          ),
        ),
        Radio<MapModeOption>(
          value: mapModeOption,
          groupValue: Get.find<ThemeController>().mapModeOption,
          onChanged: (MapModeOption? value) {
            onTap();
          },
        ),
      ],
    ),
  );
}

class ColorPickerTile extends StatelessWidget {
  final String title;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  ColorPickerTile({
    required this.title,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(title),
          SizedBox(width: 16.0),
          Container(
            height: 24,
            width: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
      onTap: () => _showColorPicker(context, color, onColorChanged),
    );
  }

  void _showColorPicker(
    BuildContext context,
    Color initialColor,
    ValueChanged<Color> onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = initialColor;

        return AlertDialog(
          title: Text('Pick a color'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() => selectedColor = color);
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                onColorChanged(selectedColor);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
